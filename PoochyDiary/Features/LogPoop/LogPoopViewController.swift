//
//  LogPoopViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

protocol LogPoopViewControllerDelegate: AnyObject {
    func onCancelButtonTap()
}

final class LogPoopViewController: UIViewController {
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
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        logPoopView.delegate = self
        navigationItem.title = "Log Poop"
        view.addAutolayoutSubview(logPoopView)

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButtonTap))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .prominent, target: self, action: #selector(handleSaveButtonTap))
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logPoopView.topAnchor.constraint(equalTo: view.topAnchor),
            logPoopView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            logPoopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logPoopView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension LogPoopViewController {
    @objc private func handleCancelButtonTap() {
        delegate?.onCancelButtonTap()
    }

    @objc private func handleSaveButtonTap() {
        
    }
}

extension LogPoopViewController: LogPoopViewDelegate {
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
