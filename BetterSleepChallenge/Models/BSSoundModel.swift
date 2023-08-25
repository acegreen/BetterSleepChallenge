//
//  BSSoundModel.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-11.
//

import Foundation

class BSSoundModel: Codable, Hashable, Equatable {
    var sound: BSComposerViewSoundType
    var volume: Float = 0.5
    var animate: Bool = false

    init(sound: BSComposerViewSoundType) {
        self.sound = sound
        self.volume = 0.5
    }
}

extension BSSoundModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(sound.rawValue)
    }
}

extension BSSoundModel {
    static func == (lhs: BSSoundModel, rhs: BSSoundModel) -> Bool {
        return lhs.sound == rhs.sound
    }
}
