//
//  PDIconLabel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/5/26.
//

import UIKit

class PDIconLabel: BaseView {
  struct Model {
    let labelText: String
    let imageName: String?
    let systemImageName: String?

    init(
      labelText: String,
      imageName: String? = nil,
      systemImageName: String? = nil
    ) {
      self.labelText = labelText
      self.imageName = imageName
      self.systemImageName = systemImageName
    }
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  private let stackView = UIStackView(
    axis: .horizontal, alignment: .center, distribution: .fill, spacing: Spacing.space2)
  private let iconView = UIImageView()
  private let label: UILabel = {
    let label = UILabel()
    label.font = .themedFont(.captionEmphasized)
    label.textColor = PoochyTheme.primaryText
    return label
  }()

  override func constructSubviews() {
    super.constructSubviews()
    stackView.addArrangedSubviews([
      iconView,
      label
    ])
    addAutolayoutSubview(stackView)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      iconView.heightAnchor.constraint(equalToConstant: 12),
      iconView.widthAnchor.constraint(equalToConstant: 12)
    ])
  }

  private func applyModel() {
    guard let model else { return }

    if let imageName = model.imageName {
      iconView.image = UIImage(named: imageName)
    } else if let systemImageName = model.systemImageName {
      iconView.image = UIImage(systemName: systemImageName)
    }

    label.text = model.labelText
  }
}
