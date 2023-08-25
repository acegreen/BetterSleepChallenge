//
//  BSComposerViewType.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-09.
//

import Foundation

enum BSComposerViewType: Codable, CaseIterable, CustomStringConvertible {
    case sounds, music

    var description: String {
        switch self {
        case .sounds:
            return "Sounds"
        case .music:
            return "Music"
        }
    }
}
