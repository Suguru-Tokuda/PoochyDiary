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

    private let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 12)

    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Photo", isOptional: true)
        return label
    }()

    private let collectionView: UICollectionView
    private let addPhotoView = AddPhotoView()
    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: 8
    )
    private let cameraButton: PDButton = {
        let button = PDButton()
        button.setTitle("Camera", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemPurple
        return button
    }()
    private let imageGalleryButton: PDButton = {
        let button = PDButton()
        button.setTitle("Gallery", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemPurple
        return button
    }()

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func constructSubviews() {
        super.constructSubviews()
        collectionView.isHidden = true
        stackView.addArrangedSubviews([

            collectionView,
            addPhotoView,
            buttonStackView
        ])
        buttonStackView.addArrangedSubviews([
            cameraButton,
            imageGalleryButton
        ])
        
        addAutolayoutSubviews([
            label,
            stackView
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            addPhotoView.heightAnchor.constraint(equalToConstant: 200),

            buttonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func applyModel() {
        let selectedImages = model?.selectedImages ?? []

        collectionView.isHidden = !selectedImages.isEmpty
        addPhotoView.isHidden = selectedImages.isEmpty
    }
}
