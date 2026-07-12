//
//  PDErrorMessageView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/22/26.
//

import UIKit

class PDErrorMessageView: BaseView {

  private let imageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.circle.fill"))
    imageView.tintColor = PoochyTheme.danger
    return imageView
  }()

  private let errorMessageLabel: UILabel = {
    let label = UILabel()
    label.textColor = PoochyTheme.danger
    label.font = .themedFont(.caption)
    label.numberOfLines = 0
    return label
  }()

  init(frame: CGRect = .zero, isHidden: Bool = false) {
    super.init(frame: frame)
    self.isHidden = isHidden
  }

  @MainActor required init?(coder: NSCoder) {
    nil
  }

  override func constructSubviews() {
    super.constructSubviews()
    addAutolayoutSubviews([
      imageView,
      errorMessageLabel
    ])
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.heightAnchor.constraint(equalToConstant: 16),
      imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
      errorMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      errorMessageLabel.leadingAnchor.constraint(
        equalTo: imageView.trailingAnchor, constant: Spacing.space4)
    ])
  }

  func setErrorMessage(_ message: String) {
    errorMessageLabel.text = message
    isHidden = message.isEmpty
  }
}
