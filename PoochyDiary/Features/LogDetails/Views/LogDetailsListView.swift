//
//  LogDetailsListView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import UIKit

class LogDetailsListView: BaseView {
    struct Model {
        let stoolType: StoolType
        let mucusLevel: MucusLevel
        let bloodAmount: BloodAmount
        let note: String?
        let tags: [Tag]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private enum Constants {
        static let cornerRadius: CGFloat = Spacing.space12
        static let iconSize: CGFloat = Spacing.space24
        static let rowPaddingV: CGFloat = Spacing.space12
        static let rowPaddingH: CGFloat = Spacing.space16
    }

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.clipsToBounds = true
        return view
    }()

    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 0
    )

    // MARK: - Constructable

    override func constructSubviews() {
        super.constructSubviews()
        containerView.addAutolayoutSubview(stackView)
        addAutolayoutSubview(containerView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),

            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

    // MARK: - Model

    private func applyModel() {
        guard let model else { return }

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        var rows: [UIView] = [
            makeIconRow(
                imageName: StoolStatusView.LabelType.stoolType.imageName,
                title: Strings.LogPoop.stoolType,
                value: model.stoolType.name
            ),
            makeIconRow(
                imageName: StoolStatusView.LabelType.mucusLevel.imageName,
                title: Strings.LogPoop.mucusLevel,
                value: model.mucusLevel.name
            ),
            makeIconRow(
                imageName: StoolStatusView.LabelType.bloodAmount.imageName,
                title: Strings.LogPoop.bloodAmount,
                value: model.bloodAmount.name
            )
        ]

        if let note = model.note, !note.isEmpty {
            rows.append(makeNoteRow(note: note))
        }

        if !model.tags.isEmpty {
            rows.append(makeTagsRow(tags: model.tags))
        }

        rows.enumerated().forEach { index, row in
            stackView.addArrangedSubview(row)
            if index < rows.count - 1 {
                stackView.addArrangedSubview(makeHorizontalDivider())
            }
        }
    }

    // MARK: - Row Builders

    private func makeIconRow(imageName: String, title: String, value: String) -> UIView {
        let container = UIView()

        let iconView = UIImageView()
        iconView.image = UIImage(named: imageName)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 14, weight: .medium)
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let hStack = UIStackView(
            axis: .horizontal,
            alignment: .center,
            distribution: .fill,
            spacing: Spacing.space12
        )
        hStack.addArrangedSubviews([iconView, titleLabel, valueLabel])
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iconView.heightAnchor.constraint(equalToConstant: Constants.iconSize),

            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.rowPaddingV),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.rowPaddingV),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.rowPaddingH),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.rowPaddingH)
        ])

        return container
    }

    private func makeNoteRow(note: String) -> UIView {
        let container = UIView()

        let titleLabel = UILabel()
        titleLabel.text = Strings.LogPoop.notes
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel

        let valueLabel = UILabel()
        valueLabel.text = note
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.numberOfLines = 0

        let vStack = UIStackView(
            axis: .vertical,
            alignment: .leading,
            distribution: .fill,
            spacing: Spacing.space4
        )
        vStack.addArrangedSubviews([titleLabel, valueLabel])
        vStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.rowPaddingV),
            vStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.rowPaddingV),
            vStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.rowPaddingH),
            vStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.rowPaddingH)
        ])

        return container
    }

    private func makeTagsRow(tags: [Tag]) -> UIView {
        let container = UIView()

        let titleLabel = UILabel()
        titleLabel.text = Strings.LogPoop.tags
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .secondaryLabel
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)

        let valueLabel = UILabel()
        valueLabel.text = tags.map(\.name).joined(separator: ", ")
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right
        valueLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let hStack = UIStackView(
            axis: .horizontal,
            alignment: .top,
            distribution: .fill,
            spacing: Spacing.space12
        )
        hStack.addArrangedSubviews([titleLabel, valueLabel])
        hStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(hStack)
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.rowPaddingV),
            hStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.rowPaddingV),
            hStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: Constants.rowPaddingH),
            hStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -Constants.rowPaddingH)
        ])

        return container
    }

    private func makeHorizontalDivider() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1)
        ])
        return view
    }
}
