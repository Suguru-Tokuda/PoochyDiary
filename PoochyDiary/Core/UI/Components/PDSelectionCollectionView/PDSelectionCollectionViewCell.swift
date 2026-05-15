//
//  PDSelectionCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

struct PDSelectionCellStyle {
    let selectedColor: UIColor
}

nonisolated struct PDSelectionItem: Hashable {
    let id: UUID
    let title: String
    let imageName: String
}

class PDSelectionCollectionViewCell: BaseCollectionViewCell {

    static var reuseIdentifier: String {
        "PDSelectionCollectionViewCell"
    }

    private enum Constants {
        static let borderRadius: CGFloat = 8
        static let padding: CGFloat = 4
        static let borderWidth: CGFloat = 1
        static let selectedBorderWidth: CGFloat = 2
        static let fontSize: CGFloat = 14
    }

    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }

    private var style: PDSelectionCellStyle?

    // MARK: - UI Elements

    private let stackView = UIStackView(axis: .vertical, alignment: .center, distribution: .fill, spacing: 0)
    private let imageView: UIImageView = {
       let imageView = UIImageView()
       imageView.contentMode = .scaleAspectFit
       imageView.translatesAutoresizingMaskIntoConstraints = false
       return imageView
    }()

    private let label: UILabel = {
       let label = UILabel()
       label.font = .systemFont(ofSize: Constants.fontSize, weight: .semibold)
       label.textAlignment = .center
       label.numberOfLines = 2
       return label
    }()

    override func constructView() {
        super.constructView()
        contentView.layer.cornerRadius = Constants.borderRadius
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.layer.borderWidth = Constants.borderWidth
        contentView.backgroundColor = .systemBackground
        contentView.layer.masksToBounds = true
    }

    override func constructSubviews() {
        stackView.addArrangedSubviews([
            imageView,
            label
        ])
        contentView.addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),

            imageView.widthAnchor.constraint(equalToConstant: 84),
            imageView.heightAnchor.constraint(equalToConstant: 84)
        ])
    }

    func configure(
        with item: PDSelectionItem,
        style: PDSelectionCellStyle
    ) {
        self.style = style

        label.text = item.title
        imageView.image = UIImage(named: item.imageName)

        updateSelectionStyle()
    }

    private func updateSelectionStyle() {
        let selectedColor = style?.selectedColor ?? .systemIndigo

        contentView.layer.borderColor = isSelected
            ? selectedColor.cgColor
            : UIColor.systemGray5.cgColor

        contentView.layer.borderWidth = isSelected
            ? Constants.selectedBorderWidth
            : Constants.borderWidth

        label.textColor = isSelected
            ? selectedColor
            : .label
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = nil
        style = nil
        updateSelectionStyle()
    }
}
