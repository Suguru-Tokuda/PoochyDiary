//
//  NewTagSectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/19/26.
//

import UIKit

class NewTagSectionView: BaseView {

    struct Model {
        let newTag: String
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    var onCreateButtonTap: (() -> Void)?

    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Create New Tag", isOptional: false)
        return label
    }()

    private let createButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "plus.circle"
        )?.withRenderingMode(.alwaysTemplate)
        config.imagePlacement = .leading
        config.imagePadding = Spacing.space8
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Spacing.space16,
            bottom: 0,
            trailing: Spacing.space16
        )

        button.configuration = config
        button.contentHorizontalAlignment = .leading

        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.accent.cgColor
        button.tintColor = .accent
        return button
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .accent
        return imageView
    }()
    private let subTitleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.textColor = .gray
        return label
    }()

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            label,
            createButton,
            subTitleView
        ])
        createButton.addAutolayoutSubview(chevronImageView)
        createButton.addTarget(self, action: #selector(handleCreateButtonTap), for: .touchUpInside)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            createButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Spacing.space8),
            createButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            createButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            createButton.heightAnchor.constraint(equalToConstant: Spacing.space40),
            subTitleView.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: Spacing.space8),
            subTitleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTitleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTitleView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: createButton.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: createButton.trailingAnchor, constant: -Spacing.space16)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        var attributedTitle = AttributedString("Create \"\(model.newTag)\"")
        attributedTitle.font = .systemFont(ofSize: 14, weight: .bold)
        attributedTitle.foregroundColor = .accent

        createButton.configuration?.attributedTitle = attributedTitle

        subTitleView.text = "\(Strings.TagSearch.noMatchingTagFound(model.newTag).stringValue)"
    }
}

extension NewTagSectionView {
    @objc private func handleCreateButtonTap() {
        onCreateButtonTap?()
    }
}
