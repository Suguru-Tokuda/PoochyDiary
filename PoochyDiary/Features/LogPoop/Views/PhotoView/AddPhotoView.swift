//
//  AddPhotoView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/16/26.
//

import UIKit

class AddPhotoView: BaseView {
    // MARK: - Closure

    var onTap: (() -> Void)?

    // MARK: - UI Components

    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .center,
        distribution: .fill,
        spacing: 4
    )
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.tintColor = .systemPurple
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let label: UILabel = {
       let label = UILabel()
       label.text = "Add Photo"
       label.font = .systemFont(ofSize: 16, weight: .medium)
       label.textColor = .systemPurple
    
       return label
    }()
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "Take a photo or upload from library"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    private let dashedBorderLayer = CAShapeLayer()

    override func constructView() {
        super.constructView()
        backgroundColor = .systemBackground
        dashedBorderLayer.strokeColor = UIColor.systemGray3.cgColor
        dashedBorderLayer.fillColor = nil
        dashedBorderLayer.lineDashPattern = [6, 4]
        dashedBorderLayer.lineWidth = 1
        dashedBorderLayer.cornerRadius = 8
        layer.addSublayer(dashedBorderLayer)
    }

    override func constructSubviews() {
        super.constructSubviews()
        stackView.addArrangedSubviews([
            imageView,
            label,
            subTitle
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dashedBorderLayer.frame = bounds
        dashedBorderLayer.path = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: 8
        ).cgPath
    }
}
