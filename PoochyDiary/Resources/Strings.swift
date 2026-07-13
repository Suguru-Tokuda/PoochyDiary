//
//  Strings.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/22/26.
//

import Foundation

nonisolated enum Strings {
    enum Common {
        static let optional = "(optional)"
        static let done = "Done"
        static let cancel = "Cancel"
        static let okay = "OK"
        static let save = "Save"
        static let edit = "Edit"
    }

    enum Tabs {
        static let home = "Home"
        static let diary = "Diary"
        static let trends = "Trends"
        static let profile = "Profile"
    }

    enum Weekday {
        static let sundayShort = "SUN"
        static let mondayShort = "MON"
        static let tuesdayShort = "TUE"
        static let wednesdayShort = "WED"
        static let thursdayShort = "THU"
        static let fridayShort = "FRI"
        static let saturdayShort = "SAT"
    }

    enum HealthValue {
        static let extraFirm = "Extra Firm"
        static let firm = "Firm"
        static let normal = "Normal"
        static let soft = "Soft"
        static let mushy = "Mushy"
        static let watery = "Watery"
        static let none = "None"
        static let trace = "Trace"
        static let mild = "Mild"
        static let moderate = "Moderate"
        static let heavy = "Heavy"
        static let speck = "Speck"
        static let streak = "Streak"
        static let large = "Large"
    }

    enum Diary {
        static let title = "Diary"
        static let trackPoop = "Track Poop"
        static let trackWeight = "Track Weight"
        static let weight = "Weight"
        static let poundsAbbreviation = "lb"
        static let kilogramsAbbreviation = "kg"
        static let jumpToDate = "Jump to Date"
        static let jump = "Jump"
        static let emptyTitle = "No diary entries for this day"
        static let emptyMessage = "Tap the + button in the top-right corner to add an entry."
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
        static let dateTimeRequired = "Select a date and time."
        static let unableToSave = "Unable to Save"

        static let yesterday = "Yesterday"
        static let today = "Today"
    }

    enum DiaryDetails {
        static let healthSignals = "Health Signals"
        static let checkCount = "3 checks"
        static let noConcerns = "No concerns"
        static let stoolType = "Stool type"
        static let mucusLevel = "Mucus level"
        static let bloodAmount = "Blood amount"

        static func photoCount(_ count: Int) -> String {
            "\(count) photo\(count == 1 ? "" : "s")"
        }
    }

    enum TagSelection {
        static let title = "Tags"
        static let subtitle = "Add diet, medication, symptoms or custom tags."
        static let searchPlaceholder = "Search or create tag..."
        static let createNewTag = "Create New Tag"
        static let addTags = "Add tags"
        static let selectedTags = "Selected Tags"
        static let tagOptions = "Tag Options"
    }

    enum Home {
        static let brand = "POOCHY DIARY"
        static let subtitle = "A calm overview before the next walk."
        static let currentStatus = "CURRENT STATUS"
        static let onTrack = "On track"
        static let lastDiary = "Last diary"
        static let diaries = "Diaries"
        static let pastSevenDays = "past 7 days"
        static let normal = "Normal"
        static let healthySigns = "healthy signs"
        static let needsReview = "needs review"
        static let watch = "Watch"
        static let none = "None"
        static let recentDiary = "Recent diary"
        static let stool = "Stool"
        static let mucus = "Mucus"
        static let blood = "Blood"
        static let newDiaryEntryAccessibilityLabel = "Diary new entry"
        static let mockStatusTitle = "Steady this week"
        static let mockStatusDetail = "Most recent diary is normal with no mucus or blood."
        static let mockLastDiary = "Today, 8:45 AM"
        static let mockInsightTitle = "Keep an eye on one watch item"
        static let mockInsightDetail =
            "A small amount of blood appeared once this week. Track the next couple of diaries for a pattern."

        static func healthDiaryTitle(petName: String) -> String {
            "\(petName)'s health diary"
        }
    }

    enum WeightEntry {
        static let title = "Log Weight"
        static let weight = "Weight"
        static let weightPlaceholder = "0.0"
        static let dateAndTime = "Date & Time"
        static let pounds = "lb"
        static let kilograms = "kg"
        static let invalidWeight = "Enter a weight greater than zero."
        static let saveFailed = "Unable to save the weight entry."
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
