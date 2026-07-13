//
//  DiaryDetailsListView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import UIKit

class DiaryDetailsListView: BaseView {
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

    private let headerRow = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.DiaryDetails.healthSignals
        label.font = .themedFont(.sectionTitle)
        label.textColor = PoochyTheme.primaryText
        return label
    }()

    private let checkCountLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.DiaryDetails.checkCount
        label.font = .themedFont(.captionEmphasized)
        label.textColor = PoochyTheme.secondaryText
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let signalsStack = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: Spacing.space12
    )

    private let stoolCard = SignalCardView()
    private let mucusCard = SignalCardView()
    private let bloodCard = SignalCardView()
    private let notesCard = NotesCardView()
    private let tagsCard = NotesCardView()

    private let contentStack = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space16
    )

    override func constructSubviews() {
        super.constructSubviews()
        headerRow.addArrangedSubviews([
            titleLabel,
            UIView(),
            checkCountLabel
        ])

        signalsStack.addArrangedSubviews([
            stoolCard,
            mucusCard,
            bloodCard
        ])

        contentStack.addArrangedSubviews([
            headerRow,
            signalsStack,
            notesCard,
            tagsCard
        ])

        addAutolayoutSubview(contentStack)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: Spacing.space16),
            contentStack.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -Spacing.space16),

            stoolCard.heightAnchor.constraint(equalToConstant: 112),
            mucusCard.heightAnchor.constraint(equalTo: stoolCard.heightAnchor),
            bloodCard.heightAnchor.constraint(equalTo: stoolCard.heightAnchor)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        stoolCard.configure(
            title: Strings.DiaryDetails.stoolType,
            value: model.stoolType.name,
            systemImageName: "circle.fill",
            iconTintColor: PoochyTheme.accent,
            iconBackgroundColor: PoochyTheme.elevatedSurface
        )
        mucusCard.configure(
            title: Strings.DiaryDetails.mucusLevel,
            value: model.mucusLevel.name,
            systemImageName: "circle.lefthalf.filled",
            iconTintColor: PoochyTheme.accent,
            iconBackgroundColor: PoochyTheme.elevatedSurface
        )
        bloodCard.configure(
            title: Strings.DiaryDetails.bloodAmount,
            value: model.bloodAmount.name,
            systemImageName: "minus.circle.fill",
            iconTintColor: PoochyTheme.attention,
            iconBackgroundColor: PoochyTheme.attention.withAlphaComponent(0.12)
        )

        if let note = model.note, !note.isEmpty {
            notesCard.isHidden = false
            notesCard.configure(title: Strings.DiaryEntry.notes, body: note)
        } else {
            notesCard.isHidden = true
        }

        if !model.tags.isEmpty {
            tagsCard.isHidden = false
            tagsCard.configure(
                title: Strings.DiaryEntry.tags, body: model.tags.map(\.name).joined(separator: ", ")
            )
        } else {
            tagsCard.isHidden = true
        }
    }
}
