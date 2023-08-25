//
//  UserDefaultsBacked.swift
//  BetterSleepChallenge
//
//  Created by Ace Green on 2023-08-09.
//

import Foundation

/*
 Use like:
 struct SomeModel {
     @UserDefaultsBacked(key: "someKey", defaults: .shared)
     var someKey: Bool
 }
 */
@propertyWrapper
public struct UserDefaultsBacked<T: Codable> {
    let key: String
    let defaultValue: T
    var storage: UserDefaults = .standard

    public init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }

    public var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = storage.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            storage.set(data, forKey: key)
        }
    }
}
