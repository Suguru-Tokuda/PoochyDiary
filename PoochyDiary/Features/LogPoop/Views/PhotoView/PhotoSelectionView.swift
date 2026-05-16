//
//  PhotoSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PhotoSelectionView: BaseView {
    struct Model {
        let selectedImages: [String]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Photo", isOptional: false)
        return label
    }()

    private let collectionView: UICollectionView

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            label
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func applyModel() {
        
    }
}
