//
//  BSSoundPlayerManager.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-10.
//

import Foundation
import AVFoundation
import UIKit

class BSSoundPlayerManager: NSObject, AVAudioPlayerDelegate {

    static let shared = BSSoundPlayerManager()

    private override init() { 
        super.init()
        setupAudioSession()
    }

    var players: [URL: AVAudioPlayer] = [:]

    // MARK: - playSound()
    func playSound(soundFileName: String, volume: Float = 0.5) {
        guard let soundFileNameURL = getSoundFileNameURL(soundFileName: soundFileName) else { return }
        if let player = players[soundFileNameURL] { //player for sound has been found
            //player is not in use, so use that one
            if !player.isPlaying {
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.volume = volume
                player.play()
            }
        } else { //player has not been found, create a new player with the URL if possible
            do {
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                players[soundFileNameURL] = player
                player.numberOfLoops = -1
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func playSounds(soundFileNames: [String]) {
        for soundFileName in soundFileNames {
            playSound(soundFileName: soundFileName)
        }
    }

    func playSounds(soundFileNames: String...) {
        for soundFileName in soundFileNames {
            playSound(soundFileName: soundFileName)
        }
    }

    // MARK: - playSounds(..., withDelay)
    //withDelay is in seconds
    func playSounds(soundFileNames: [String], withDelay: Double) {
        for (index, soundFileName) in soundFileNames.enumerated() {
            let delay = withDelay * Double(index)
            let _ = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(playSoundNotification(_:)), userInfo: ["fileName": soundFileName], repeats: false)
        }
    }

    @objc func playSoundNotification(_ notification: NSNotification) {
        if let soundFileName = notification.userInfo?["fileName"] as? String {
            playSound(soundFileName: soundFileName)
        }
    }

    func pause(soundFileName: String? = nil) {
        if let soundFileNameURL = getSoundFileNameURL(soundFileName: soundFileName) {
            players[soundFileNameURL]?.pause()
        } else {
            players.map { $0.value }.forEach { $0.pause() }
        }
    }

    // pass nil to function to clear all
    func clear(soundFileName: String? = nil) {
        if let soundFileNameURL = getSoundFileNameURL(soundFileName: soundFileName) {
            players.removeValue(forKey: soundFileNameURL)
        } else {
            players.removeAll()
        }
    }

    func clear(soundFileNames: [String]) {
        for soundFileName in soundFileNames {
            clear(soundFileName: soundFileName)
        }
    }

    func getSoundFileNameURL(soundFileName: String?) -> URL? {
        guard let soundFileName, let bundle = Bundle.main.path(forResource: soundFileName, ofType: "caf") else { return nil }
        return URL(fileURLWithPath: bundle)
    }

    // MARK: - setAudioSession for background modes
    func setupAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    // MARK: - audioPlayerDidFinishPlaying
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) { }
}
