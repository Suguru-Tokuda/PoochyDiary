//
//  FullScreenImageViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/5/26.
//

import UIKit

class FullScreenImageViewCell: BaseCollectionViewCell {

    class var reuseIdentifier: String { "FullScreenImageViewCell" }

    struct Model {
        let imageURL: URL?
        let image: UIImage?

        init(imageURL: URL?, image: UIImage? = nil) {
            self.imageURL = imageURL
            self.image = image
        }
    }

    var model: Model? {
        didSet { applyModel() }
    }

    /// The currently loaded image — used by the dismiss transition to snapshot the right frame.
    var currentImage: UIImage? { imageView.image }

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()

    // MARK: - Constructable

    override func constructSubviews() {
        super.constructSubviews()
        contentView.addAutolayoutSubview(imageView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Model

    private func applyModel() {
        guard let model else { return }
        if let imageURL = model.imageURL {
            imageView.setImageURL(imageURL)
        } else if let image = model.image {
            imageView.image = image
        }
    }
}
