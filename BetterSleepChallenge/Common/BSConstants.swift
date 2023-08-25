//
//  BSConstants.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-09.
//

import Foundation

class BSConstants {

    static let shared = BSConstants()

    // MARK: - USERDEFAULTSKEY
    struct USERDEFAULTSKEY {
        static let SELECTEDSOUNDNAMES = "SELECTEDSOUNDNAMES"
    }

    static let soundslimit = 3

    @UserDefaultsBacked(key: BSConstants.USERDEFAULTSKEY.SELECTEDSOUNDNAMES, defaultValue: [])
    private(set) var selectedSoundNames: [String]

    func setSelectedSoundNames(selectedSoundNames: [String]) {
        self.selectedSoundNames = selectedSoundNames
    }
}
