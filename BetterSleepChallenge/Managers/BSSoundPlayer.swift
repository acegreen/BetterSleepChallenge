//
//  BSSoundPlayer.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-08.
//

import Foundation
import AVFoundation

class BSSoundPlayerManager: NSObject, AVAudioPlayerDelegate {

    static let shared = BSSoundPlayerManager()

    private override init() { }

    var players: [URL: AVAudioPlayer] = [:]

    func playSound(soundFileName: String) {

        guard let bundle = Bundle.main.path(forResource: soundFileName, ofType: "caf") else { return }
        let soundFileNameURL = URL(fileURLWithPath: bundle)

        if let player = players[soundFileNameURL] { //player for sound has been found
            if !player.isPlaying { //player is not in use, so use that one
                player.prepareToPlay()
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

    func playSounds(soundFileNames: [String], withDelay: Double) { //withDelay is in seconds
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
        if let soundFileName, let bundle = Bundle.main.path(forResource: soundFileName, ofType: "caf") {
            let soundFileNameURL = URL(fileURLWithPath: bundle)
            players[soundFileNameURL]?.pause()
        } else {
            players.map { $0.value }.forEach { $0.pause() }
        }
    }

    func clear(soundFileName: String? = nil) {
        if let soundFileName, let bundle = Bundle.main.path(forResource: soundFileName, ofType: "caf") {
            let soundFileNameURL = URL(fileURLWithPath: bundle)
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

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {

    }
}
