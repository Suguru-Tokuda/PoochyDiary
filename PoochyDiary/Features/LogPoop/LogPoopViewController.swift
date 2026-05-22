//
//  LogPoopViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

protocol LogPoopViewControllerDelegate: AnyObject {
    func onCancelButtonTap()
    func onDateTimeLabelTap()
    func onTagsTap()
    func onCameraButtonTap()
    func onImageGalleryButtonTap()
}

final class LogPoopViewController: BaseViewController {
    weak var delegate: LogPoopViewControllerDelegate?

    let viewModel: LogPoopViewModel
    let logPoopView = LogPoopView()
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: LogPoopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addSubscriptions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    @MainActor deinit {
        subscriptions.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        logPoopView.configure(
            dateTime: viewModel.dateTime,
            stoolType: viewModel.stoolType,
            mucusLevel: viewModel.mucusLevel,
            bloodAmount: viewModel.bloodAmount,
            photos: viewModel.photos,
            notes: viewModel.notes,
            tags: viewModel.tags
        )
    }

    override func constructView() {
        super.constructView()
        navigationItem.title = "Log Poop"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButtonTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .prominent, target: self, action: #selector(handleSaveButtonTap))
    }

    override func constructSubviews() {
        super.constructSubviews()
        logPoopView.delegate = self
        view.addAutolayoutSubview(logPoopView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            logPoopView.topAnchor.constraint(equalTo: view.topAnchor),
            logPoopView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            logPoopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logPoopView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func addSubscriptions() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }

                logPoopView.configure(dateTime: state.dateTime,
                                      stoolType: state.stoolType,
                                      mucusLevel: state.mucusLevel,
                                      bloodAmount: state.bloodAmount,
                                      photos: state.photos,
                                      notes: state.notes,
                                      tags: state.tags
                )
            }
            .store(in: &subscriptions)

        viewModel.$errors
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errors in
                guard let self else { return }

                logPoopView.configure(errors: errors)
            }
            .store(in: &subscriptions)
    }
}

extension LogPoopViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        viewModel.notes = textView.text
    }
}

extension LogPoopViewController {
    @objc private func handleCancelButtonTap() {
        delegate?.onCancelButtonTap()
    }

    @objc private func handleSaveButtonTap() {
        do {
            try viewModel.save()
        } catch {
            // TODO: Show error
        }
    }

    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardFrameInView = view.convert(keyboardFrame, from: nil)
        let intersection = view.bounds.intersection(keyboardFrameInView)
        let bottomInset = intersection.height

        logPoopView.setBottomInset(bottomInset)
        logPoopView.textViewDidBeginEditing()
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        logPoopView.setBottomInset(0)
    }
}

extension LogPoopViewController: LogPoopViewDelegate {
    
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
