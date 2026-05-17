//
//  LogPoopViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

protocol LogPoopViewControllerDelegate: AnyObject {
    func onCancelButtonTap()
    func onDateTimeLabelTap()
}

final class LogPoopViewController: BaseViewController {
    weak var delegate: LogPoopViewControllerDelegate?

    let viewModel: LogPoopViewModel
    let logPoopView = LogPoopView()

    init(viewModel: LogPoopViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
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
}

extension LogPoopViewController {
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}

extension LogPoopViewController {
    @objc private func handleCancelButtonTap() {
        delegate?.onCancelButtonTap()
    }

    @objc private func handleSaveButtonTap() {
        
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
    
    func onDateTimeChanged(dateTime: Date) {
    }
    
    func onStoolTypeChanged(stoolType: StoolType) {
    }
    
    func onMucusLevelChanged(mucusLevel: MucusLevel) {
    }
    
    func onBloodAmountChanged(bloodAmount: BloodAmount) {
    }
    
    func onPhotoSelectionChanged(photos: [UIImage]) {
    }
    
    func onNotesChanged(notes: String) {
    }
    
    func onTagsChanged(tags: [Tag]) {
    }
}
