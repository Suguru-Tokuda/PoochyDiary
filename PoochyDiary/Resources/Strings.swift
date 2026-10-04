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
        static let unavailableValue = "—"

        static func accessibilityValue(title: String, value: String) -> String {
            "\(title): \(value)"
        }

        static func commaSeparated(_ values: [String]) -> String {
            values.joined(separator: ", ")
        }
    }

    enum Chart {
        static let poops = "Poops"
        static let blood = "Blood"
        static let mucus = "Mucus"
        static let selectedDate = "Selected date"
        static let day = "Day"
        static let count = "Count"
        static let category = "Category"
        static let totalPoops = "Total Poops"
        static let zeroPercentage = "0%"

        static func stoolTypeTitle(number: Int) -> String {
            "Type \(number)"
        }
    }

    enum Trends {
        static let summary = "Summary"
        static let showDetails = "Show details"
        static let hideDetails = "Hide details"
        static let poopTrends = "Poop trends"
        static let bloodObserved = "Blood observed"
        static let mucusObserved = "Mucus observed"
        static let totalPoops = "Total poops"
        static let dailyAverage = "Daily average"
        static let currentWeight = "Current weight"
        static let averageWeight = "Average weight"
        static let noWeightsLogged = "No weight measurements for this period"
        static let weightAverageExplanation = "Average is based on logged weight measurements."
        static let daysLogged = "Days logged"
        static let noDatesLogged = "No dates logged"
        static let noPoopsLogged = "No poops logged"
        static let percentageExplanation =
            "Percentages are based on logged poops.\nA record can include both blood and mucus."

        static func timeFrameTitle(days: Int) -> String {
            "\(days) days"
        }

        static func weightTrendTitle(unit: String) -> String {
            "Weight trends (\(unit))"
        }

        static func weightMeasurements(count: Int) -> String {
            "\(count) weight measurement\(count == 1 ? "" : "s")"
        }

        static func loggedPoopCount(count: Int) -> String {
            "\(count) logged poop\(count == 1 ? "" : "s")"
        }

        static func loggedPoops(count: Int, total: Int) -> String {
            "\(count) of \(total) logged poops"
        }

        static func daysLoggedValue(logged: Int, total: Int) -> String {
            "\(logged) / \(total)"
        }

        static func percentageAccessibilityLabel(
            title: String,
            percentage: String,
            countDescription: String
        ) -> String {
            "\(title): \(percentage), \(countDescription)"
        }
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

        static func dateHeader(date: String, relativeDay: String?) -> String {
            guard let relativeDay else { return date }
            return "\(relativeDay) • \(date)"
        }

        static func weightValue(weight: String, unit: String) -> String {
            "\(weight) \(unit)"
        }
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

        static func accessibilityLabel(petName: String, animalType: String) -> String {
            "\(petName), \(animalType)"
        }

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

        static func createTagTitle(name: String) -> String {
            "Create \"\(name)\""
        }
    }

    enum Home {
        static let brand = "POOCHY DIARY"
        static let subtitle = "A calm overview before the next walk."
        static let currentStatus = "CURRENT STATUS"
        static let onTrack = "On track"
        static let lastDiary = "Last diary"
        static let diaries = "Diaries"
        static let pastSevenDays = "past 7 days"
        static let weeklyOverview = "Weekly Overview"
        static let poops = "Poops"
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
        static let mockWeeklyDiaries = "6"
        static let mockNormalDiaries = "4/6"
        static let mockWatchItems = "1"
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

    enum FullScreenImage {
        static func pageCount(current: Int, total: Int) -> String {
            "\(current) / \(total)"
        }
    }

    enum Typography {
        static let heroTitle = "Hero Title"
        static let screenTitle = "Screen Title"
        static let sectionTitle = "Section Title"
        static let cardTitle = "Card Title"
        static let body = "Body"
        static let bodyEmphasized = "Body Emphasized"
        static let caption = "Caption"
        static let captionEmphasized = "Caption Emphasized"
        static let pill = "Pill"
        static let button = "Button"
        static let metric = "Metric"
        static let heroTitleUsage = "Primary status or detail titles."
        static let screenTitleUsage = "Top-level page titles."
        static let sectionTitleUsage = "Section headers such as Photos or Health Signals."
        static let cardTitleUsage = "Compact card headings and smaller modules."
        static let bodyUsage = "Paragraphs, notes, and normal descriptive text."
        static let bodyEmphasizedUsage = "Important body values and short field values."
        static let captionUsage = "Secondary timestamps and helper labels."
        static let captionEmphasizedUsage = "Small metadata with extra emphasis."
        static let pillUsage = "Badges, chips, and overline labels."
        static let buttonUsage = "Primary and secondary button titles."
        static let metricUsage = "Dashboard counts and prominent numeric values."
    }

    enum Mock {
        static let leo = "Leo"
        static let taiga = "Taiga"
        static let jin = "Jin"

        static let notesByStool: [StoolType: [String]] = [
            .extraFirm: [
                "Very hard and dry today, she seemed to strain a bit getting it out.",
                "Small hard pellets, harder than her usual. Adding more water to her bowl.",
                "Straining more than normal, stool was quite dry and compact."
            ],
            .firm: [
                "Firm and well-formed, no straining. Good easy walk this morning.",
                "Solid stool, picked up easily. Normal color and consistency.",
                "Firm but not hard, everything looked routine.",
                "A little firmer than usual but no signs of discomfort."
            ],
            .normal: [
                "Solid and well-formed, no straining. Back to her normal routine.",
                "Normal morning routine. Quick and easy, no issues.",
                "Good color and consistency, nothing unusual to note.",
                "Textbook normal stool today, she seemed happy on the walk.",
                "Everything looked great, easy pickup, good shape."
            ],
            .soft: [
                "Softer than usual this evening. Might be from the new treats.",
                "A bit loose today, no blood or mucus though. Will monitor.",
                "Soft serve consistency, still held together okay.",
                "Slightly soft, maybe from all the water she drank after the park."
            ],
            .mushy: [
                "Mushy and harder to pick up today. She got into some grass on the walk.",
                "Loose and mushy, no blood or mucus present. Watching her diet today.",
                "Not fully formed, a little concerning but she's acting normal otherwise."
            ],
            .watery: [
                "Watery stool, definitely upset stomach. Keeping her hydrated and monitoring closely.",
                "Very loose and watery this time. Will call the vet if it continues past tomorrow.",
                "Runny and hard to clean up. She seems a little low energy today too."
            ]
        ]

        static func mucusNote(level: String) -> String {
            "Noticed \(level) mucus coating, keeping an eye on it."
        }

        static func bloodNote(amount: String) -> String {
            "Saw a \(amount) amount of blood — will monitor it."
        }
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
