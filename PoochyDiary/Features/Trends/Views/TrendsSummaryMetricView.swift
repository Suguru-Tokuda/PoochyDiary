import UIKit

final class TrendsSummaryMetricView: BaseView {

    // MARK: - UI elements

    private let stack: UIStackView = UIStackView(
        axis: .vertical,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.numberOfLines = 0
        label.textAlignment = .center
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.metric)
        label.textColor = PoochyTheme.primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.outline
        return view
    }()

    init(title: String, showsDivider: Bool) {
        super.init(frame: .zero)
        titleLabel.text = title
        divider.isHidden = !showsDivider
        update(value: Strings.Common.unavailableValue)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func constructView() {
        isAccessibilityElement = true
    }

    override func constructSubviews() {
        stack.addArrangedSubviews([
            titleLabel,
            valueLabel
        ])
        addAutolayoutSubviews([stack, divider])
    }

    override func constructSubviewLayoutConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space4),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space4),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.topAnchor.constraint(equalTo: topAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.widthAnchor.constraint(equalToConstant: 1)
        ])
    }

    func update(value: String) {
        valueLabel.text = value
        accessibilityLabel = Strings.Common.accessibilityValue(title: titleLabel.text ?? "", value: value)
    }

    func setDividerHidden(_ hidden: Bool) {
        divider.isHidden = hidden
    }
}
