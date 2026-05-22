//
//  DateTimePickerView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/16/26.
//

import UIKit

class DateTimePickerView: BaseView {
    var onCancel: (() -> Void)?
    var onDone: ((Date?) -> Void)?

    struct Model {
        let date: Date?
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()

    private let actionBarView = ActionBarView()

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            datePicker,
            actionBarView
        ])
        actionBarView.onCancel = { [weak self] in
            self?.onCancel?()
        }

        actionBarView.onDone = { [weak self] in
            guard let self else { return }
            onDone?(datePicker.date)
        }
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: actionBarView.topAnchor),
            actionBarView.heightAnchor.constraint(equalToConstant: 48),
            actionBarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            actionBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func applyModel() {
        guard let date = model?.date else { return }

        datePicker.date = date
    }
}
