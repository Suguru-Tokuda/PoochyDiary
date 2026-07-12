//
//  AppConfiguration.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import Foundation

enum AppConfiguration {
    static var useMockData: Bool {
        #if DEBUG
            ProcessInfo.processInfo.arguments.contains("-useMockData")
        #else
            false
        #endif
    }
}
