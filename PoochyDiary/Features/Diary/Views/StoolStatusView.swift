//
//  StoolStatusView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/1/26.
//

import UIKit

class StoolStatusView: BaseView {
  enum LabelType {
    case stoolType
    case mucusLevel
    case bloodAmount

    var imageName: String {
      switch self {
      case .stoolType:
        return "stoolTypeIcon"
      case .mucusLevel:
        return "mucusLevelIcon"
      case .bloodAmount:
        return "bloodAmountIcon"
      }
    }
  }

  struct Model {
    let stoolType: StoolType
    let mucusLevel: MucusLevel
    let bloodAmount: BloodAmount
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  private let stackView = UIStackView(
    axis: .horizontal,
    alignment: .fill,
    distribution: .fill,
    spacing: Spacing.space4
  )

  private let stoolTypeLabel = PDIconLabel()
  private let mucusLevelLabel = PDIconLabel()
  private let bloodLevelLabel = PDIconLabel()
  private let divider1 = makeDivider()
  private let divider2 = makeDivider()

  override func constructSubviews() {
    super.constructSubviews()
    stackView.addArrangedSubviews([
      stoolTypeLabel,
      divider1,
      mucusLevelLabel,
      divider2,
      bloodLevelLabel,
    ])

    [stoolTypeLabel, mucusLevelLabel, bloodLevelLabel].forEach {
      $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    addAutolayoutSubview(stackView)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      divider1.widthAnchor.constraint(equalToConstant: 0.5),
      divider1.heightAnchor.constraint(equalToConstant: 12),
      divider2.widthAnchor.constraint(equalToConstant: 0.5),
      divider2.heightAnchor.constraint(equalToConstant: 12),
    ])
  }

  private func applyModel() {
    guard let model else { return }

    stoolTypeLabel.model = PDIconLabel.Model(
      labelText: model.stoolType.name, imageName: LabelType.stoolType.imageName)
    mucusLevelLabel.model = PDIconLabel.Model(
      labelText: model.mucusLevel.name, imageName: LabelType.mucusLevel.imageName)
    bloodLevelLabel.model = PDIconLabel.Model(
      labelText: model.bloodAmount.name, imageName: LabelType.bloodAmount.imageName)
  }

  private static func makeLabel() -> UILabel {
    let label = UILabel()
    label.font = .themedFont(.caption)
    return label
  }

  private static func makeDivider() -> UIView {
    let view = UIView()
    view.backgroundColor = PoochyTheme.outline
    return view
  }
}
