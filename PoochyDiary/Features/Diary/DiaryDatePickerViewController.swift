//
//  DiaryDatePickerViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class DiaryDatePickerViewController: BaseViewController {
    var onCancel: (() -> Void)?
    var onDateSelect: ((Date) -> Void)?

    private let selectedDate: Date
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        return datePicker
    }()

    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func constructView() {
        super.constructView()
        title = "Jump to Date"
        view.backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        datePicker.date = selectedDate
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(handleCancel)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Jump",
            style: .prominent,
            target: self,
            action: #selector(handleDateSelect)
        )
        view.addAutolayoutSubview(datePicker)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.space8),
            datePicker.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: Spacing.space16),
            datePicker.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Spacing.space16)
        ])
    }

    @objc private func handleCancel() {
        onCancel?()
    }

    @objc private func handleDateSelect() {
        onDateSelect?(datePicker.date)
    }
}
