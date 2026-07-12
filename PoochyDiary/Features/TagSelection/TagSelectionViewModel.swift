//
//  TagSelectionViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import Combine
import Foundation

class TagSelectionViewModel {
  @Published var searchText: String? {
    didSet {
      filterTagOptionsBySearchText()
      checkNewTagCreation()
    }
  }

  private var tagOptions: [Tag] = []
  var selectedTags: [Tag] {
    selectedTagOptionsSubject.value
  }

  private let selectedTagOptionsSubject: CurrentValueSubject<[Tag], Never>
  private let filteredTagOptionsSubject: CurrentValueSubject<[Tag], Never>

  var newTagPublisher = PassthroughSubject<String, Never>()
  var selectedTagOptionsPublisher: AnyPublisher<[Tag], Never> {
    selectedTagOptionsSubject.eraseToAnyPublisher()
  }

  var filteredTagOptionsPublisher: AnyPublisher<[Tag], Never> {
    filteredTagOptionsSubject.eraseToAnyPublisher()
  }

  init(
    selectedTags: [Tag] = [],
    tagOptions: [Tag] = []
  ) {
    let sortedSelectedTags = selectedTags.sorted { $0.name < $1.name }
    let sortedTagOptions = tagOptions.sorted { $0.name < $1.name }

    self.tagOptions = sortedTagOptions
    self.selectedTagOptionsSubject = CurrentValueSubject(sortedSelectedTags)
    self.filteredTagOptionsSubject = CurrentValueSubject(sortedTagOptions)
    filterTagOptionsForSelectedTags()
  }

  func filterTagOptionsBySearchText() {
    guard let searchText,
      !searchText.isEmpty
    else {
      if selectedTagOptionsSubject.value.isEmpty {
        filteredTagOptionsSubject.send(tagOptions)
      } else {
        filteredTagOptionsSubject.send(filteredTagOptionsSubject.value)
      }

      return
    }

    let loweredSearchText = searchText.lowercased()
    let selectedTagIds = Set(selectedTagOptionsSubject.value.map { $0.id })

    var filteredTagOptions = tagOptions.filter({ !selectedTagIds.contains($0.id) })
    filteredTagOptions = filteredTagOptions.filter({
      $0.name.lowercased().contains(loweredSearchText)
    })
    filteredTagOptionsSubject.send(filteredTagOptions)
  }

  func selectTag(tag: Tag) {
    var selectedTags = selectedTagOptionsSubject.value
    selectedTags.append(tag)
    selectedTags.sort(by: { $0.name < $1.name })
    selectedTagOptionsSubject.send(selectedTags)
    filterTagOptionsForSelectedTags()
  }

  func deselectTag(tag: Tag) {
    var selectedTags = selectedTagOptionsSubject.value
    selectedTags.removeAll(where: { $0.id == tag.id })
    selectedTagOptionsSubject.send(selectedTags)
    filterTagOptionsForSelectedTags()
  }

  func createNewTag() {
    guard let searchText,
      !searchText.isEmpty
    else {
      return
    }

    let newTagText = searchText.trimmingCharacters(in: .whitespaces)
    let newTag = Tag(id: UUID(), name: newTagText)
    selectTag(tag: newTag)
    //        var selectedTags = selectedTagOptionsSubject.value
    //        selectedTags.append(newTag)
    //        selectedTagOptionsSubject.value = selectedTags.sorted(by: { $0.name < $1.name })

    if !tagOptions.contains(where: { $0.id == newTag.id }) {
      var newTagOptions = tagOptions
      newTagOptions.append(newTag)
      tagOptions = newTagOptions.sorted(by: { $0.name < $1.name })
    }

    self.searchText = nil
  }
}

// MARK: - private functions

extension TagSelectionViewModel {
  private func filterTagOptionsForSelectedTags() {
    let selectedTagIds = Set(selectedTagOptionsSubject.value.map { $0.id })
    var filteredTagOptions = tagOptions
    filteredTagOptions = filteredTagOptions.filter({ !selectedTagIds.contains($0.id) })
    filteredTagOptionsSubject.send(filteredTagOptions)
  }

  private func checkNewTagCreation() {
    guard let searchText,
      !searchText.isEmpty
    else {
      newTagPublisher.send("")
      return
    }
    let searchTextLower = searchText.trimmingCharacters(in: .whitespaces).lowercased()
    if tagOptions.filter({ $0.name.lowercased() == searchTextLower }).isEmpty {
      newTagPublisher.send(searchText.trimmingCharacters(in: .whitespaces))
    } else {
      newTagPublisher.send("")
    }
  }
}
