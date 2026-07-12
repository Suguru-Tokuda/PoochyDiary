//
//  DiaryDetailsViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import Combine
import UIKit

protocol DiaryDetailsViewControllerDelegate: AnyObject {
  func diaryDetailsViewController(
    _ viewController: DiaryDetailsViewController,
    didSelectPhotoAt index: Int,
    sourceView: UIView,
    photos: [Photo]
  )
  func editButtonTap()
}

class DiaryDetailsViewController: BaseViewController {
  private let viewModel: DiaryDetailsViewModel
  private var subscriptions = Set<AnyCancellable>()

  weak var delegate: DiaryDetailsViewControllerDelegate?

  // MARK: - UIComponents

  private let diaryDetailsView = DiaryDetailsView()

  init(viewModel: DiaryDetailsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @MainActor required init?(coder: NSCoder) {
    nil
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addSubscriptions()
    view.backgroundColor = PoochyTheme.background

    diaryDetailsView.onPhotoSelect = { [weak self] index, sourceView in
      guard let self else { return }
      let photos = viewModel.state.diary.photos
      delegate?.diaryDetailsViewController(
        self, didSelectPhotoAt: index, sourceView: sourceView, photos: photos)
    }
  }

  override func constructSubviews() {
    super.constructSubviews()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Edit",
      style: .plain,
      target: self,
      action: #selector(handleEditButtonTap)
    )
    view.addAutolayoutSubview(diaryDetailsView)
    view.backgroundColor = PoochyTheme.background
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()

    NSLayoutConstraint.activate([
      diaryDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
      diaryDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      diaryDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      diaryDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }

  private func addSubscriptions() {
    viewModel
      .$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        self?.diaryDetailsView.model = DiaryDetailsView.Model(
          pet: state.pet,
          diary: state.diary
        )
      }
      .store(in: &subscriptions)
  }
}

extension DiaryDetailsViewController {
  @objc private func handleEditButtonTap() {
    delegate?.editButtonTap()
  }
}
