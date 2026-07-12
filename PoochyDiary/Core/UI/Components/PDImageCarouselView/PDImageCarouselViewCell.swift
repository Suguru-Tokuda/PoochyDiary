//
//  PDImageCarouselViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/5/26.
//

import UIKit

class PDImageCarouselViewCell: BaseCollectionViewCell {

    class var reuseIdentifer: String {
        "PDImageCarouselViewCell"
    }

    struct Model {
        let imageURL: URL?
        let image: UIImage?

        init(imageURL: URL?, image: UIImage? = nil) {
            self.imageURL = imageURL
            self.image = image
        }
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    /// The currently loaded image — used by the zoom transition animator.
    var thumbnailImage: UIImage? { imageView.image }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override func constructView() {
        super.constructView()
        contentView.layer.cornerRadius = 8
    }

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

    private func applyModel() {
        guard let model else { return }
        if let imageURL = model.imageURL {
            imageView.setImageURL(imageURL)
        } else if let image = model.image {
            imageView.image = image
        }
    }
}
