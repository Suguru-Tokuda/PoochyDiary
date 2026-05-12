//
//  PDSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

final class PDSelectionView: BaseView {
    struct Model {
        let text: String
        let image: UIImage?
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    // MARK: - UI Components

    private let stackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.alignment = .center
      stackView.distribution = .fill
      return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func constructView() {
        super.constructView()
        layer.cornerRadius = 8
        layer.borderColor = UIColor.systemGray5.cgColor
        layer.borderWidth = 1
        backgroundColor = .systemBackground
    }

    override func constructSubviews() {
        super.constructSubviews()
        stackView.addArrangedSubviews([
            titleLabel,
            imageView
        ])
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 48),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        titleLabel.text = model.text
        imageView.image = model.image
    }
}
