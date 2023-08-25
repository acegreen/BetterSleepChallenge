//
//  BSComposerViewSoundType.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-09.
//

import Foundation
import SwiftUI

enum BSComposerViewSoundType: String, Codable, CaseIterable, CustomStringConvertible {
    case birds, flute, lounge, music_box, ocean, orchestral, piano, rain, wind

    var imageResource: ImageResource {
        return ImageResource(name: "\(self.rawValue.camelCase())-Normal", bundle: Bundle.main)
    }

    var selectedImageResource: ImageResource {
        return ImageResource(name: "\(self.rawValue.camelCase())-Selected", bundle: Bundle.main)
    }

    var description: String {
        switch self {
        case .birds:
            return "Birds"
        case .flute:
            return "Flute"
        case .lounge:
            return "Lounge"
        case .music_box:
            return "Music Box"
        case .ocean:
            return "Ocean"
        case .orchestral:
            return "Orchestral"
        case .piano:
            return "Piano"
        case .rain:
            return "Rain"
        case .wind:
            return "Wind"
        }
    }

    var soundFileName: String {
        return self.rawValue.replacingOccurrences(of: "_", with: "")
    }
}
