//
//  BSComposerViewFilterType.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-09.
//

import Foundation

enum BSComposerViewFilterType: Codable, CaseIterable, CustomStringConvertible {
    case all, myFavorite, new, recent

    var description: String {
        switch self {
        case .all:
            return "All"
        case .myFavorite:
            return "My ♥️"
        case .new:
            return "New"
        case .recent:
            return "Recent"
        }
    }
}
