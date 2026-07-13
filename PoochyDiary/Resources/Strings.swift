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
        static let diary = "Diary"
        static let trends = "Trends"
        static let profile = "Profile"
    }

    enum Diary {
        static let title = "Diary"
        static let selectDateAccessibilityLabel = "Select diary date"
        static let addEntryAccessibilityLabel = "Add diary entry"
    }

    enum PetSelector {
        static let accessibilityHint = "Double tap to switch pets"

        static func accessibilityLabel(petName: String) -> String {
            "Current pet, \(petName)"
        }
    }

    enum PetSelection {
        static let title = "Switch Pet"
        static let subtitle = "Choose whose diary you want to view"
        static let addPet = "Add a Pet"
        static let closeAccessibilityLabel = "Close pet selection"

        static func animalType(_ type: AnimalType) -> String {
            switch type {
            case .cat:
                return "Cat"
            case .dog:
                return "Dog"
            }
        }
    }

    enum DiaryEntry {
        static let title = "Diary Poop"

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
