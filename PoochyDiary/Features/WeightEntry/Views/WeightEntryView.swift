//
//  WeightEntryView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/13/26.
//

import UIKit

final class WeightEntryView: BaseView {
    var onWeightChange: ((String) -> Void)?
    var onUnitChange: ((WeightUnit) -> Void)?
    var onDateChange: ((Date) -> Void)?
    var onCancelButtonTap: (() -> Void)?
    var onSaveButtonTap: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.WeightEntry.title
        label.font = .themedFont(.sectionTitle)
        label.textColor = PoochyTheme.primaryText
        label.accessibilityTraits = .header
        return label
    }()

    private let weightTitleLabel = WeightEntryView.makeFieldLabel(Strings.WeightEntry.weight)
    private let dateTitleLabel = WeightEntryView.makeFieldLabel(Strings.WeightEntry.dateAndTime)

    private let weightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Strings.WeightEntry.weightPlaceholder
        textField.keyboardType = .decimalPad
        textField.font = .themedFont(.metric)
        textField.textColor = PoochyTheme.primaryText
        textField.backgroundColor = PoochyTheme.surface
        textField.layer.borderColor = PoochyTheme.outline.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = Spacing.space12
        textField.textAlignment = .center
        return textField
    }()

    private let unitControl = UISegmentedControl(items: [
        Strings.WeightEntry.pounds,
        Strings.WeightEntry.kilograms
    ])

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        return picker
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.danger
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    private let cancelButton: PDButton = {
        let button = PDButton()
        button.setTitle(Strings.Common.cancel, for: .normal)
        button.setTitleColor(PoochyTheme.primaryText, for: .normal)
        button.backgroundColor = PoochyTheme.surface
        return button
    }()

    private let saveButton: PDButton = {
        let button = PDButton()
        button.setTitle(Strings.Common.save, for: .normal)
        button.setTitleColor(PoochyTheme.white, for: .normal)
        button.backgroundColor = PoochyTheme.accent
        return button
    }()

    private let weightStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: Spacing.space8
    )

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        unitControl.selectedSegmentIndex = 0
        weightStackView.addArrangedSubviews([weightTextField, unitControl])
        buttonStackView.addArrangedSubviews([cancelButton, saveButton])

        addAutolayoutSubviews([
            titleLabel,
            weightTitleLabel,
            weightStackView,
            dateTitleLabel,
            datePicker,
            errorLabel,
            buttonStackView
        ])

        weightTextField.addTarget(self, action: #selector(handleWeightChange), for: .editingChanged)
        unitControl.addTarget(self, action: #selector(handleUnitChange), for: .valueChanged)
        datePicker.addTarget(self, action: #selector(handleDateChange), for: .valueChanged)
        cancelButton.addTarget(self, action: #selector(handleCancelButtonTap), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(handleSaveButtonTap), for: .touchUpInside)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),
            weightTitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Spacing.space24
            ),
            weightTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            weightStackView.topAnchor.constraint(
                equalTo: weightTitleLabel.bottomAnchor,
                constant: Spacing.space8
            ),
            weightStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            weightStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            weightStackView.heightAnchor.constraint(equalToConstant: Spacing.space48),
            unitControl.widthAnchor.constraint(equalToConstant: 120),
            dateTitleLabel.topAnchor.constraint(
                equalTo: weightStackView.bottomAnchor,
                constant: Spacing.space16
            ),
            dateTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            datePicker.centerYAnchor.constraint(equalTo: dateTitleLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            errorLabel.topAnchor.constraint(
                equalTo: dateTitleLabel.bottomAnchor,
                constant: Spacing.space12
            ),
            errorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -Spacing.space16
            ),
            buttonStackView.heightAnchor.constraint(equalToConstant: Spacing.space48)
        ])
    }

    func showError(_ message: String?) {
        errorLabel.text = message
        errorLabel.isHidden = message == nil
    }

    func setSaving(_ isSaving: Bool) {
        saveButton.isEnabled = !isSaving
        cancelButton.isEnabled = !isSaving
    }

    private static func makeFieldLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .themedFont(.bodyEmphasized)
        label.textColor = PoochyTheme.primaryText
        return label
    }

    @objc private func handleWeightChange() {
        onWeightChange?(weightTextField.text ?? "")
        showError(nil)
    }

    @objc private func handleUnitChange() {
        onUnitChange?(unitControl.selectedSegmentIndex == 0 ? .pounds : .kilograms)
    }

    @objc private func handleDateChange() {
        onDateChange?(datePicker.date)
    }

    @objc private func handleCancelButtonTap() {
        onCancelButtonTap?()
    }

    @objc private func handleSaveButtonTap() {
        endEditing(true)
        onSaveButtonTap?()
    }
}
