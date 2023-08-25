//
//  String+Extensions.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-10.
//

import Foundation

extension String {
    
    // MARK: - CamelCase
    func camelCase() -> String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .map { $0.capitalized }
            .joined()
    }

    mutating func camelCased() {
        self = self.camelCase()
    }
}
