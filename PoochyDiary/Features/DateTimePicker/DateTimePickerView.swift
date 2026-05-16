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

    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: 8
    )

    private let doneButton: PDButton = {
        let button = PDButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        return button
    }()

    private let cancelButton: PDButton = {
        let button = PDButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemGray
        return button
    }()

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            datePicker,
            buttonStackView
        ])

        buttonStackView.addArrangedSubviews([
            cancelButton,
            doneButton
        ])

        doneButton.addTarget(self, action: #selector(handleDoneButtonTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(handleCancelButtonTap), for: .touchUpInside)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor),
            buttonStackView.heightAnchor.constraint(equalToConstant: 48),
            buttonStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func applyModel() {
        guard let date = model?.date else { return }

        datePicker.date = date
    }
}

extension DateTimePickerView {
    @objc private func handleDoneButtonTap() {
        onDone?(datePicker.date)
    }

    @objc private func handleCancelButtonTap() {
        onCancel?()
    }
}
