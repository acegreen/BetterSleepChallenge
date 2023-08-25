//
//  BSSoundComposerViewModel.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-09.
//

import Foundation
import SwiftUI

@Observable
class BSSoundPlayerViewModel {
    static let shared = BSSoundPlayerViewModel()

    var selectedSounds: [BSSoundModel] = []
    var isPlaying: Bool = false

    // MARK: - add/remove/update
    func add(soundModel: BSSoundModel) {
        self.selectedSounds.append(soundModel)
        saveUserDefaults()
    }

    func remove(soundModel: BSSoundModel) {
        if let index = selectedSounds.firstIndex(of: soundModel) {
            selectedSounds.remove(at: index)
            saveUserDefaults()
        }
    }

    func update(oldValue: [BSSoundModel], newValue: [BSSoundModel], autoplay: Bool) {
        // if selectedSounds is empty, clear player
        guard !selectedSounds.isEmpty else {
            clear()
            return
        }

        // user unselected a sound, clear it from player
        let unselectedSounds = oldValue.filter { !newValue.contains($0) }
        for unselectedSound in unselectedSounds {
            clear(sound: unselectedSound.sound)
        }

        //
        if unselectedSounds.isEmpty && autoplay {
            play()
        }
    }

    // MARK: - play()
    /* pass nil to function to play all */
    func play() {
        for soundModel in selectedSounds {
            BSSoundPlayerManager.shared.playSound(soundFileName: soundModel.sound.soundFileName, volume: soundModel.volume)
        }
        isPlaying = true
    }

    // MARK: - pause()
    func pause() {
        BSSoundPlayerManager.shared.pause()
        isPlaying = false
    }

    // MARK: - clear()
    /* pass nil to function to clear all */
    func clear(sound: BSComposerViewSoundType? = nil) {
        BSSoundPlayerManager.shared.clear(soundFileName: sound?.soundFileName)
        saveUserDefaults()
        if sound == nil {
            selectedSounds = []
            clearUserDefaults()
            isPlaying = false
        }
    }

    // MARK: - saveUserDefaults
    private func saveUserDefaults() {
        BSUserStoreManager.shared.setSelectedSoundNames(selectedSoundNames: selectedSounds.map { $0.sound.soundFileName })
    }

    // MARK: - clearUserDefaults
    private func clearUserDefaults() {
        BSUserStoreManager.shared.setSelectedSoundNames(selectedSoundNames: [])
    }
}

class MockBSSoundPlayerViewModel: BSSoundPlayerViewModel {

    override init() {
        super.init()
        self.selectedSounds = []
    }
}
