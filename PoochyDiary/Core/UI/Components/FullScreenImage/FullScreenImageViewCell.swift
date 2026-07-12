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
    var currentImage: UIImage? {
        zoomableImageView.image
    }

    private let zoomableImageView: ZoomableImageView = {
        let imageView = ZoomableImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - Constructable

    override func constructSubviews() {
        super.constructSubviews()
        contentView.addAutolayoutSubview(zoomableImageView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            zoomableImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            zoomableImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            zoomableImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            zoomableImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        zoomableImageView.image = nil
        zoomableImageView.resetZoom()
    }

    func resetZoom() {
        zoomableImageView.resetZoom()
    }

    // MARK: - Model

    private func applyModel() {
        guard let model else { return }
        if let imageURL = model.imageURL {
            zoomableImageView.setImageURL(imageURL)
        } else if let image = model.image {
            zoomableImageView.image = image
        }
    }
}
