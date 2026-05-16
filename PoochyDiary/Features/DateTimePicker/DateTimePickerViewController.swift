//
//  DateTimePickerViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/16/26.
//

import UIKit

class DateTimePickerViewController: BaseViewController {
    var onCancelButtonTap: (() -> Void)?
    var onDoneButtonTap: ((Date?) -> Void)?

    let viewModel: DateTimePickerViewModel

    let datePickerView = DateTimePickerView()

    init(viewModel: DateTimePickerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        datePickerView.model = DateTimePickerView.Model(date: viewModel.date)
    }
    
    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()
        view.addAutolayoutSubview(datePickerView)

        datePickerView.onCancel = { [weak self] in
            self?.onCancelButtonTap?()
        }

        datePickerView.onDone = { [weak self] date in
            self?.onDoneButtonTap?(date)
        }
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            datePickerView.topAnchor.constraint(equalTo: view.topAnchor),
            datePickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            datePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            datePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
