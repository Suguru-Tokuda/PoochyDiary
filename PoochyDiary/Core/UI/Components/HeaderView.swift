//
//  HeaderView.swift
//  PoochyDiary
//

import UIKit

final class HeaderView: BaseView {
    var onPetSelectorTap: (() -> Void)?

    var title: String? {
        didSet {
            updateTitle()
        }
    }

    var petName: String? {
        didSet {
            updatePetSelector()
        }
    }

    var trailingButtons: [UIButton] = [] {
        didSet {
            updateTrailingButtons()
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.sectionTitle)
        label.textColor = PoochyTheme.primaryText
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byTruncatingTail
        label.accessibilityTraits = .header
        label.isHidden = true
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let petSelectorView: PetSelectorView = {
        let view = PetSelectorView()
        view.isHidden = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }()

    private let spacerView: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        view.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        return view
    }()

    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let contentStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )

    init(frame: CGRect = .zero, title: String? = nil) {
        self.title = title
        super.init(frame: frame)
        updateTitle()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()

        contentStackView.addArrangedSubviews([
            titleLabel,
            petSelectorView,
            spacerView,
            buttonStackView
        ])
        addAutolayoutSubview(contentStackView)

        petSelectorView.onTap = { [weak self] in
            self?.onPetSelectorTap?()
        }
        updateTrailingButtons()
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: Spacing.space40)
        ])
    }

    private func updateTitle() {
        titleLabel.text = title
        titleLabel.isHidden = title?.isEmpty != false
    }

    private func updatePetSelector() {
        guard let petName, !petName.isEmpty else {
            petSelectorView.isHidden = true
            return
        }

        petSelectorView.model = PetSelectorView.Model(name: petName, image: nil)
        petSelectorView.isHidden = false
    }

    private func updateTrailingButtons() {
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttonStackView.addArrangedSubviews(trailingButtons)
        buttonStackView.isHidden = trailingButtons.isEmpty
    }
}
