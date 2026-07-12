//
//  DiaryEntryViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

protocol DiaryEntryViewControllerDelegate: AnyObject {
  func onCancelButtonTap()
  func onDateTimeLabelTap()
  func onTagsTap()
  func onCameraButtonTap()
  func onImageGalleryButtonTap()
}

final class DiaryEntryViewController: BaseViewController {
  weak var delegate: DiaryEntryViewControllerDelegate?

  let viewModel: DiaryEntryViewModel
  let diaryEntryView = DiaryEntryView()
  private var subscriptions = Set<AnyCancellable>()

  init(viewModel: DiaryEntryViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    addSubscriptions()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    nil
  }

  @MainActor deinit {
    removeSubscriptions()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    configureDiaryEntryView(with: viewModel.state)
  }

  override func constructView() {
    super.constructView()
    navigationItem.title = "Diary Poop"
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButtonTap))
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Save", style: .prominent, target: self, action: #selector(handleSaveButtonTap))
  }

  override func constructSubviews() {
    super.constructSubviews()
    diaryEntryView.delegate = self
    view.addAutolayoutSubview(diaryEntryView)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      diaryEntryView.topAnchor.constraint(equalTo: view.topAnchor),
      diaryEntryView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      diaryEntryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      diaryEntryView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  private func addSubscriptions() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillChangeFrame),
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )

    viewModel
      .$state
      .receive(on: DispatchQueue.main)
      .sink { [weak self] state in
        guard let self else { return }
        configureDiaryEntryView(with: state)
      }
      .store(in: &subscriptions)

    viewModel
      .$errors
      .receive(on: DispatchQueue.main)
      .sink { [weak self] errors in
        guard let self else { return }

        diaryEntryView.configure(errors: errors)
      }
      .store(in: &subscriptions)

    viewModel
      .saveErrorPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] error in
        self?.presentSaveError(error)
      }
      .store(in: &subscriptions)
  }

  private func configureDiaryEntryView(with state: DiaryEntryViewModel.State) {
    diaryEntryView.configure(
      model: DiaryEntryView.Model(
        dateTime: state.dateTime,
        stoolType: state.stoolType,
        mucusLevel: state.mucusLevel,
        bloodAmount: state.bloodAmount,
        photos: state.photos,
        notes: state.notes,
        tags: state.tags
      ))
  }

  private func presentSaveError(_ error: Error) {
    let alert = UIAlertController(
      title: "Unable to Save",
      message: error.localizedDescription,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }

  private func removeSubscriptions() {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil
    )
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    subscriptions.removeAll()
  }
}

extension DiaryEntryViewController {
  func textViewDidBeginEditing(_ textView: UITextView) {
    viewModel.notes = textView.text
  }
}

extension DiaryEntryViewController {
  @objc private func handleCancelButtonTap() {
    delegate?.onCancelButtonTap()
  }

  @objc private func handleSaveButtonTap() {
    viewModel.save { [weak self] result in
      guard let self else { return }

      switch result {
      case .success:
        delegate?.onCancelButtonTap()
      case .failure:
        // Show error
        break
      }
    }
  }

  @objc private func keyboardWillChangeFrame(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
      let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
    else { return }

    let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
    let intersection = view.bounds.intersection(keyboardFrameInView)
    let bottomInset = intersection.height

    diaryEntryView.setBottomInset(bottomInset)
    diaryEntryView.textViewDidBeginEditing()
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    diaryEntryView.setBottomInset(0)
  }
}

extension DiaryEntryViewController: DiaryEntryViewDelegate {

  func onDateTimeTap() {
    delegate?.onDateTimeLabelTap()
  }

  func onStoolTypeChanged(item: PDSelectionItem) {
    viewModel.setStoolType(item: item)
  }

  func onMucusLevelChanged(item: PDSelectionItem) {
    viewModel.setMucusLevel(item: item)
  }

  func onBloodAmountChanged(item: PDSelectionItem) {
    viewModel.setBloodAmount(item: item)
  }

  func onPhotoSelectionChanged(photos: [Photo]) {
    viewModel.photos = photos
  }

  func onRemovePhoto(photo: Photo) {
    viewModel.removePhoto(photo: photo)
  }

  func onNotesChanged(notes: String) {
    viewModel.notes = notes
  }

  func onTagsTap() {
    delegate?.onTagsTap()
  }

  func onCameraButtonTap() {
    delegate?.onCameraButtonTap()
  }

  func onImageGalleryButtonTap() {
    delegate?.onImageGalleryButtonTap()
  }
}
