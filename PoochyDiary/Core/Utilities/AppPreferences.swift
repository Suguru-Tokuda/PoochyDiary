//
//  AppPreferences.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/13/26.
//

import Combine
import Foundation

protocol AppPreferencing: AnyObject {
    var weightUnit: WeightUnit { get set }
    var weightUnitPublisher: AnyPublisher<WeightUnit, Never> { get }
}

final class AppPreferences: AppPreferencing {
    private enum Key {
        static let weightUnit = "weightUnit"
    }

    private let userDefaults: UserDefaults
    private let weightUnitSubject: CurrentValueSubject<WeightUnit, Never>

    var weightUnit: WeightUnit {
        get {
            weightUnitSubject.value
        }
        set {
            guard newValue != weightUnitSubject.value else { return }

            userDefaults.set(
                newValue.rawValue,
                forKey: Key.weightUnit
            )
            weightUnitSubject.send(newValue)
        }
    }

    var weightUnitPublisher: AnyPublisher<WeightUnit, Never> {
        weightUnitSubject
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        let storedValue = userDefaults.string(forKey: Key.weightUnit)
        let weightUnit = storedValue.flatMap(WeightUnit.init(rawValue:)) ?? .pounds
        weightUnitSubject = CurrentValueSubject(weightUnit)
    }
}
