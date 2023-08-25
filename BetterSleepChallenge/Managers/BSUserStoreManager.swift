//
//  BSUserStoreManager.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-13.
//

import Foundation

class BSUserStoreManager {

    static let shared = BSConstants()

    // MARK: - Properties
    @UserDefaultsBacked(key: BSConstants.USERDEFAULTSKEY.SELECTEDSOUNDNAMES, defaultValue: [])
    private(set) var selectedSoundNames: [String]

    func setSelectedSoundNames(selectedSoundNames: [String]) {
        self.selectedSoundNames = selectedSoundNames
    }
}
