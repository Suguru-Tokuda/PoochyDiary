//
//  LogPoopCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit
import PhotosUI

final class LogPoopCoordinator: BaseCoordinator {
    private let dependencies: AppDependency
    private var viewModel: LogPoopViewModel?

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        guard let imageFileManager = dependencies.imageFileManager,
              let poochyDiaryCoreDataManager = dependencies.poochyDiaryCoreDataManager else { return }
        let viewModel = LogPoopViewModel(coreDataManager: poochyDiaryCoreDataManager,
                                         imageFileManager: imageFileManager)
        let viewController = LogPoopViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
        self.viewModel = viewModel
    }
}

extension LogPoopCoordinator {
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

extension LogPoopCoordinator: LogPoopViewControllerDelegate {
    
    func onCancelButtonTap() {
        navigationController.popViewController(animated: true)
        finish()
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
        guard let logPoopViewModel = viewModel else { return }

        let viewModel = TagSelectionViewModel(
            selectedTags: logPoopViewModel.tags,
            tagOptions: logPoopViewModel.tagOptions
        )
        let viewController = TagSelectionViewController(viewModel: viewModel)
        viewController.isModalInPresentation = true
        viewController.onCancelButtonTap = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }
        viewController.onDoneButtonTap = { [weak self] selectedTags in
            guard let self else { return }
            navigationController.dismiss(animated: true)
            logPoopViewModel.tags = selectedTags
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

extension LogPoopCoordinator: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let viewModel,
              let image = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }

        viewModel.addPhoto(image: image)
        picker.dismiss(animated: true)
    }
}

extension LogPoopCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self,
                  let viewModel,
                  let image = object as? UIImage else { return }

            viewModel.addPhoto(image: image)
            picker.dismiss(animated: true)
        }
    }
}
