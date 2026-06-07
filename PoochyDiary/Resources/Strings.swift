//
//  Strings.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/22/26.
//

import Foundation

enum Strings {
    enum Tabs {
        static let home = "Home"
        static let history = "History"
        static let trends = "Trends"
        static let profile = "Profile"
    }

    enum LogPoop {
        static let title = "Log Poop"

        // Form fields
        static let stoolType = "Stool Type"
        static let mucusLevel = "Mucus Level"
        static let bloodAmount = "Blood Amount"
        static let dateAndTime = "Date & Time"
        static let notes = "Notes"
        static let camera = "Camera"
        static let gallery = "Gallery"
        static let photos = "Photos"
        static let tags = "Tags"

        static let selectDate = "Select Date"
        static let notesPlaceholder = "Add any notes about this poop..."
        static let addPhoto = "Add Photo"
        static let takePhoto = "Take a photo or upload from library"

        static let stoolTypeRequired = "Select a stool type."
        static let mucusLevelRequired = "Select a mucus level."
        static let bloodAmountRequired = "Select a blood amount."

        static let yesterday = "Yesterday"
        static let today = "Today"
    }

    enum TagSearch {
        case noMatchingTagFound(String)

        var stringValue: String {
            switch self {
            case .noMatchingTagFound(let newTag):
                return "No exact match found. Create a new tag \(newTag)"
            }
        }
    }
}
