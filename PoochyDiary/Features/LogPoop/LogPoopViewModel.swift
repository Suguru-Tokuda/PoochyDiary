//
//  LogPoopViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

enum LogPoopValidationError {
    case dateTimeRequired
    case stoolTypeRequired
    case mucusLevelRequired
    case bloodAmountRequired

    var message: String {
        switch self {
        case .dateTimeRequired:
            return "Select a date and time."
        case .stoolTypeRequired:
            return "Select a stool type."
        case .mucusLevelRequired:
            return "Select a mucus level."
        case .bloodAmountRequired:
            return "Select a blood amount."
        }
    }
}

class LogPoopViewModel {

    struct State {
        var dateTime: Date?
        var stoolType: StoolType?
        var mucusLevel: MucusLevel?
        var bloodAmount: BloodAmount?
        var photos: [Photo]
        var notes: String?
        var tags: [Tag]

        var isDirty: Bool = false

        var isValid: Bool {
            dateTime != nil &&
            stoolType != nil &&
            mucusLevel != nil &&
            bloodAmount != nil
        }
    }

    @Published private(set) var state: State {
        didSet {
            validate()
        }
    }
    private var submitted = false
    @Published private(set) var errors: [LogPoopValidationError] = []
    private(set) var tagOptions: [Tag] = []
    var pet: Pet?

    // MARK: - Dependencies

    let coreDataManager: PoochyDiaryCoreDataManaging
    let imageFileManager: ImageFileManaging

    init(
        state: State = State(
            dateTime: nil,
            stoolType: nil,
            mucusLevel: nil,
            bloodAmount: nil,
            photos: [],
            notes: nil,
            tags: []
        ),
        coreDataManager: PoochyDiaryCoreDataManaging,
        imageFileManager: ImageFileManaging
    ) {
        self.state = state
        self.coreDataManager = coreDataManager
        self.imageFileManager = imageFileManager
        do {
            self.tagOptions = try coreDataManager.getAllTags()
        } catch {
        }
    }

    func addPhoto(image: UIImage) {
        guard let pet else { return }

        var state = state
        let createdAt = Date()
        state.photos.append(Photo(
            id: UUID(),
            fileName: "\(pet.id.uuidString)-photo-\(createdAt.description)",
            createdAt: createdAt,
            sortOrder: state.photos.count
        ))

        photos = state.photos
    }

    func validate() {
        guard submitted else { return }

        var errors: [LogPoopValidationError] = []

        if state.dateTime == nil {
            errors.append(.dateTimeRequired)
        }

        if state.stoolType == nil {
            errors.append(.stoolTypeRequired)
        }

        if state.mucusLevel == nil {
            errors.append(.mucusLevelRequired)
        }

        if state.bloodAmount == nil {
            errors.append(.bloodAmountRequired)
        }

        self.errors = errors
    }

    func save() throws {
        submitted = true
        validate()
        guard state.isValid else {
            return
        }
    }

    func setStoolType(item: PDSelectionItem) {
        guard let stoolType = StoolType.allCases.first(where: { $0.id == item.id }) else {
            return
        }

        self.stoolType = stoolType
    }

    func setMucusLevel(item: PDSelectionItem) {
        guard let mucusLevel = MucusLevel.allCases.first(where: { $0.id == item.id }) else {
            return
        }

        self.mucusLevel = mucusLevel
    }

    func setBloodAmount(item: PDSelectionItem) {
        guard let bloodAmount = BloodAmount.allCases.first(where: { $0.id == item.id }) else {
            return
        }

        self.bloodAmount = bloodAmount
    }
}

extension LogPoopViewModel {

    var dateTime: Date? {
        get {
            state.dateTime
        }
        set {
            state.dateTime = newValue
        }
    }

    var stoolType: StoolType? {
        get {
            state.stoolType
        }
        set {
            state.stoolType = newValue
        }
    }

    var mucusLevel: MucusLevel? {
        get {
            state.mucusLevel
        }
        set {
            state.mucusLevel = newValue
        }
    }

    var bloodAmount: BloodAmount? {
        get {
            state.bloodAmount
        }
        set {
            state.bloodAmount = newValue
        }
    }

    var photos: [Photo] {
        get {
            state.photos
        }
        set {
            state.photos = newValue
        }
    }

    var notes: String? {
        get {
            state.notes
        }
        set {
            state.notes = newValue
        }
    }

    var tags: [Tag] {
        get {
            state.tags
        }
        set {
            state.tags = newValue
        }
    }

    var isDirty: Bool {
        get {
            state.isDirty
        }
    }
}
