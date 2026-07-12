//
//  DiaryDetailsCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import Combine
import UIKit

final class DiaryDetailsCoordinator: BaseCoordinator {
  private let dependencies: AppDependency
  private let pet: Pet
  private let diary: Diary

  private var viewController: DiaryDetailsViewController?
  private var subscriptions = Set<AnyCancellable>()

  /// Retained for the lifetime of the coordinator so the transition delegate isn't deallocated
  /// while a presentation is in flight.
  private let zoomDelegate = ZoomTransitionDelegate()

  init(
    pet: Pet,
    diary: Diary,
    navigationController: UINavigationController,
    dependencies: AppDependency
  ) {
    self.pet = pet
    self.diary = diary
    self.dependencies = dependencies
    super.init(navigationController)
  }

  override func start() {
    let viewModel = DiaryDetailsViewModel(pet: pet, diary: diary)
    let viewController = DiaryDetailsViewController(viewModel: viewModel)
    viewController.delegate = self

    navigationController.pushViewController(viewController, animated: true)

    if let navigationController = navigationController as? BaseNavigationController {
      navigationController
        .popPublisher(for: viewController)
        .sink { [weak self] _ in
          self?.finish()
        }
        .store(in: &subscriptions)
    }

    self.viewController = viewController
  }
}

// MARK: - DiaryDetailsViewControllerDelegate

extension DiaryDetailsCoordinator: DiaryDetailsViewControllerDelegate {
  func diaryDetailsViewController(
    _ viewController: DiaryDetailsViewController,
    didSelectPhotoAt index: Int,
    sourceView: UIView,
    photos: [Photo]
  ) {
    // Capture the source thumbnail's image before presenting
    let sourceImage = (sourceView as? PDImageCarouselViewCell)?.thumbnailImage

    zoomDelegate.sourceView = sourceView
    zoomDelegate.sourceImage = sourceImage

    let fullScreenVM = FullScreenImageViewModel(photos: photos, startIndex: index)
    let fullScreenVC = FullScreenImageViewController(viewModel: fullScreenVM)
    fullScreenVC.modalPresentationStyle = .custom
    fullScreenVC.transitioningDelegate = zoomDelegate
    navigationController.present(fullScreenVC, animated: true)
  }

  func editButtonTap() {
    let diaryEntryCoordinator = DiaryEntryCoordinator(
      navigationController, pet: pet,
      diary: diary,
      dependencies: dependencies
    )
    addChild(diaryEntryCoordinator)
    diaryEntryCoordinator.start()
  }
}
