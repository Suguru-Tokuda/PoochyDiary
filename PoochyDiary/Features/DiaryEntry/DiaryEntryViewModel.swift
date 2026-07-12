//
//  DiaryEntryViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

enum DiaryEntryValidationError {
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

class DiaryEntryViewModel {

  struct State {
    var diaryId: UUID = UUID()
    var dateTime: Date?
    var stoolType: StoolType?
    var mucusLevel: MucusLevel?
    var bloodAmount: BloodAmount?
    var photos: [Photo]
    var removePhotos: [Photo] = []
    var notes: String?
    var tags: [Tag]
    var date: Date?

    var isDirty: Bool = false

    var isValid: Bool {
      dateTime != nil && stoolType != nil && mucusLevel != nil && bloodAmount != nil
    }
  }

  @Published private(set) var state: State {
    didSet {
      validate()
    }
  }
  private var submitted = false
  @Published private(set) var errors: [DiaryEntryValidationError] = []
  var saveErrorPublisher = PassthroughSubject<Error, Never>()
  private(set) var tagOptions: [Tag] = []
  let pet: Pet
  private var saveTask: Task<Void, Never>?

  // MARK: - Dependencies

  let coreDataManager: PoochyDiaryCoreDataManaging
  let imageFileManager: ImageFileManaging

  init(
    pet: Pet,
    diary: Diary?,
    coreDataManager: PoochyDiaryCoreDataManaging,
    imageFileManager: ImageFileManaging
  ) {
    self.pet = pet
    if let diary {
      state = State(
        dateTime: diary.date,
        stoolType: diary.stoolType,
        mucusLevel: diary.mucusLevel,
        bloodAmount: diary.bloodAmount,
        photos: diary.photos,
        notes: diary.notes,
        tags: diary.tags
      )
    } else {
      self.state = State(
        dateTime: nil,
        stoolType: nil,
        mucusLevel: nil,
        bloodAmount: nil,
        photos: [],
        notes: nil,
        tags: []
      )
    }
    self.coreDataManager = coreDataManager
    self.imageFileManager = imageFileManager
    do {
      self.tagOptions = try coreDataManager.getAllTags()
    } catch {
    }
  }

  func addPhoto(image: UIImage) {
    var state = state
    let createdAt = Date()
    state.photos.append(
      Photo(
        id: UUID(),
        fileName:
          "\(pet.id.uuidString)-\(state.diaryId.uuidString)-photo-\(createdAt.description.replacingOccurrences(of: " ", with: "_"))",
        image: image,
        createdAt: createdAt,
        sortOrder: state.photos.count
      ))

    photos = state.photos
  }

  func removePhoto(photo: Photo) {
    var state = state
    var photos = state.photos
    var removePhotos = state.removePhotos
    photos.removeAll(where: { $0.id == photo.id })

    if removePhotos.contains(where: { $0.id == photo.id }) {
      removePhotos.append(photo)
    }

    state.photos = photos
    state.removePhotos = removePhotos
    self.state = state
  }

  func validate() {
    guard submitted else { return }

    var errors: [DiaryEntryValidationError] = []

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

  func save(completion: @escaping (Result<Void, Error>) -> Void) {
    submitted = true
    validate()

    guard saveTask == nil,
      state.isValid,
      let stoolType = state.stoolType,
      let mucusLevel = state.mucusLevel,
      let bloodAmount = state.bloodAmount
    else {
      return
    }

    saveTask = Task(priority: .userInitiated) { [weak self] in
      guard let self else { return }

      state.removePhotos.forEach {
        guard !$0.fileName.isEmpty else { return }
        try? self.imageFileManager.deleteImage(fileName: $0.fileName)
      }

      var photos = state.photos

      photos.enumerated().forEach { (index, photo) in
        guard let image = photo.image else { return }

        if let savedURL = try? self.imageFileManager.saveImage(
          image: image, fileName: photo.fileName)
        {
          var photo = photo
          photo.imageURL = savedURL
          photos[index] = photo
        }
      }

      do {
        try await coreDataManager.saveDiary(
          diary:
            Diary(
              id: state.diaryId,
              petId: pet.id,
              date: state.date ?? Date(),
              stoolType: stoolType,
              mucusLevel: mucusLevel,
              bloodAmount: bloodAmount,
              photos: photos,
              tags: state.tags))
        await MainActor.run {
          completion(.success(()))
        }
      } catch {
        completion(.failure(error))
      }
      saveTask = nil
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

extension DiaryEntryViewModel {

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
    state.isDirty
  }
}
