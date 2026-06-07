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
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let imageView: UIImageView = {
       let imageView = UIImageView()
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

    private func applyModel() {
        guard let imageURL = model?.imageURL else { return }

        imageView.setImageURL(imageURL)
    }
}
