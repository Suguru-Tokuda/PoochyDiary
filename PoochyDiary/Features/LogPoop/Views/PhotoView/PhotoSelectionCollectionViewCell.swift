//
//  PhotoSelectionCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/11/26.
//

import UIKit

class PhotoSelectionCollectionViewCell: BaseCollectionViewCell {
    class var reuseIdentifier: String {
        "PhotoSelectionCollectionViewCell"
    }

    struct Model {
        let imageURL: URL?
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    // MARK: - UI Components

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        return imageView
    }()

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

    private func applyModel() {
        guard let model,
              let imageURL = model.imageURL else { return }

        imageView.setImageURL(imageURL)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
