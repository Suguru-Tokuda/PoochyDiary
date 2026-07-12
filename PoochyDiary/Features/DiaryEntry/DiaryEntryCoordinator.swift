//
//  DiaryEntryCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import PhotosUI
import UIKit

final class DiaryEntryCoordinator: BaseCoordinator {
  private let dependencies: AppDependency
  private var viewModel: DiaryEntryViewModel?
  private var subscriptions = Set<AnyCancellable>()

  init(
    _ navigationController: UINavigationController,
    pet: Pet,
    diary: Diary? = nil,
    dependencies: AppDependency
  ) {
    self.dependencies = dependencies
    super.init(navigationController)
    if let imageFileManager = dependencies.imageFileManager,
      let poochyDiaryCoreDataManager = dependencies.poochyDiaryCoreDataManager
    {
      viewModel = DiaryEntryViewModel(
        pet: pet,
        diary: diary,
        coreDataManager: poochyDiaryCoreDataManager,
        imageFileManager: imageFileManager
      )
    }
  }

  override func start() {
    guard let viewModel else { return }
    let viewController = DiaryEntryViewController(viewModel: viewModel)
    viewController.delegate = self
    viewController.hidesBottomBarWhenPushed = true

    navigationController.pushViewController(viewController, animated: true)

    if let navigationController = navigationController as? BaseNavigationController {
      navigationController
        .popPublisher(for: viewController)
        .sink { [weak self] in self?.finish() }
        .store(in: &subscriptions)
    }
  }
}

extension DiaryEntryCoordinator {
  private func openCamera() {
    let picker = UIImagePickerController()
    picker.sourceType = .camera
    picker.delegate = self
    picker.allowsEditing = false

    navigationController.present(picker, animated: true)
  }

  private func openPhotoLibrary() {
    guard let viewModel else { return }
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 10 - viewModel.photos.count
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    navigationController.present(picker, animated: true)
  }
}

extension DiaryEntryCoordinator: DiaryEntryViewControllerDelegate {
  func onCancelButtonTap() {
    navigationController.popViewController(animated: true)
  }

  func onDateTimeLabelTap() {
    let viewModel = DateTimePickerViewModel()
    let viewController = DateTimePickerViewController(viewModel: viewModel)
    viewController.isModalInPresentation = true
    viewController.onCancelButtonTap = { [weak self] in
      self?.navigationController.dismiss(animated: true)
    }

    viewController.onDoneButtonTap = { [weak self] selectedDate in
      guard let self else { return }
      navigationController.dismiss(animated: true)
      self.viewModel?.dateTime = selectedDate
    }

    if let sheet = viewController.sheetPresentationController {
      sheet.detents = [.medium()]
      sheet.prefersGrabberVisible = false
    }

    navigationController.present(viewController, animated: true)
  }

  func onTagsTap() {
    guard let diaryEntryViewModel = viewModel else { return }

    let viewModel = TagSelectionViewModel(
      selectedTags: diaryEntryViewModel.tags,
      tagOptions: diaryEntryViewModel.tagOptions
    )
    let viewController = TagSelectionViewController(viewModel: viewModel)
    viewController.isModalInPresentation = true
    viewController.onCancelButtonTap = { [weak self] in
      self?.navigationController.dismiss(animated: true)
    }
    viewController.onDoneButtonTap = { [weak self] selectedTags in
      guard let self else { return }
      navigationController.dismiss(animated: true)
      diaryEntryViewModel.tags = selectedTags
    }

    if let sheet = viewController.sheetPresentationController {
      sheet.detents = [.large()]
      sheet.prefersGrabberVisible = false
    }

    navigationController.present(viewController, animated: true)
  }

  func onCameraButtonTap() {
    openCamera()
  }

  func onImageGalleryButtonTap() {
    openPhotoLibrary()
  }
}

extension DiaryEntryCoordinator: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let viewModel,
      let image = info[.originalImage] as? UIImage
    else {
      picker.dismiss(animated: true)
      return
    }

    viewModel.addPhoto(image: image)
    picker.dismiss(animated: true)
  }
}

extension DiaryEntryCoordinator: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    results.forEach { result in
      result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
        guard let self,
          let viewModel,
          let image = object as? UIImage
        else { return }

        viewModel.addPhoto(image: image)
      }
    }

    DispatchQueue.main.async {
      picker.dismiss(animated: true)
    }
  }
}
