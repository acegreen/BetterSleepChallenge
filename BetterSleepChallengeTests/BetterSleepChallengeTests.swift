//
//  BetterSleepChallengeTests.swift
//  BetterSleepChallengeTests
//
//  Created by Ace Green on 2023-08-10.
//

import XCTest
@testable import BetterSleepChallenge

final class BetterSleepChallengeTests: XCTestCase {

    var mockViewModel = MockBSSoundPlayerViewModel()

    override func setUpWithError() throws { }

    func testAddSound() throws {
        let soundModel = BSSoundModel(sound: .birds)
        mockViewModel.add(soundModel: soundModel)
        XCTAssert(mockViewModel.selectedSounds.first { $0 == soundModel } != nil)
    }

    func testRemoveSound() throws {
        let soundModel = BSSoundModel(sound: .birds)
        mockViewModel.add(soundModel: soundModel)
        XCTAssert(mockViewModel.selectedSounds.first { $0 == soundModel } != nil)
        mockViewModel.remove(soundModel: soundModel)
        XCTAssert(mockViewModel.selectedSounds.contains{ $0 == soundModel } == false)
    }

    override func tearDownWithError() throws { }
}
