import UIKit

final class TrendsPercentageCardView: BaseView {
    private var verticalPaddingConstraints: [NSLayoutConstraint] = []
    private var progressHeightConstraint: NSLayoutConstraint?

    // MARK: - UI Elements

    private let contentStack: UIStackView = UIStackView(
        axis: .vertical,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let headerStack: UIStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let indicator: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Spacing.space4
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.heroTitle)
        label.textColor = PoochyTheme.primaryText
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.trackTintColor = PoochyTheme.secondaryText.withAlphaComponent(0.2)
        view.isAccessibilityElement = false
        return view
    }()

    init(title: String, color: UIColor) {
        super.init(frame: .zero)
        titleLabel.text = title
        indicator.backgroundColor = color
        progressView.progressTintColor = color
        update(fraction: nil, count: 0, total: 0)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func constructView() {
        backgroundColor = PoochyTheme.surface
        layer.cornerRadius = Spacing.space16
        layer.cornerCurve = .continuous
        isAccessibilityElement = true
    }

    override func constructSubviews() {
        headerStack.addArrangedSubviews([indicator, titleLabel])
        contentStack.addArrangedSubviews([headerStack, percentageLabel, countLabel, progressView])
        contentStack.setCustomSpacing(Spacing.space12, after: countLabel)
        addAutolayoutSubview(contentStack)
    }

    override func constructSubviewLayoutConstraints() {
        verticalPaddingConstraints = [
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space16)
        ]
        let progressHeight = progressView.heightAnchor.constraint(equalToConstant: Spacing.space8)
        progressHeightConstraint = progressHeight
        NSLayoutConstraint.activate(verticalPaddingConstraints)
        NSLayoutConstraint.activate([
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),
            indicator.widthAnchor.constraint(equalToConstant: Spacing.space8),
            indicator.heightAnchor.constraint(equalTo: indicator.widthAnchor),
            progressHeight
        ])
    }

    func setExpanded(_ expanded: Bool) {
        progressHeightConstraint?.isActive = expanded
        countLabel.isHidden = !expanded
        progressView.isHidden = !expanded
        percentageLabel.font = .themedFont(expanded ? .heroTitle : .metric)
        verticalPaddingConstraints.first?.constant = expanded ? Spacing.space16 : Spacing.space12
        verticalPaddingConstraints.last?.constant = expanded ? -Spacing.space16 : -Spacing.space12

        if expanded, percentageLabel.superview !== contentStack {
            headerStack.removeArrangedSubview(percentageLabel)
            percentageLabel.removeFromSuperview()
            contentStack.insertArrangedSubview(percentageLabel, at: 1)
        } else if !expanded, percentageLabel.superview !== headerStack {
            contentStack.removeArrangedSubview(percentageLabel)
            percentageLabel.removeFromSuperview()
            headerStack.addArrangedSubview(percentageLabel)
        }
    }

    func update(fraction: Double?, count: Int, total: Int) {
        percentageLabel.text = fraction?.formatted(.percent.precision(.fractionLength(0)))
            ?? Strings.Common.unavailableValue
        countLabel.text = total > 0
            ? Strings.Trends.loggedPoops(count: count, total: total)
            : Strings.Trends.noPoopsLogged
        progressView.progress = Float(min(1, max(0, fraction ?? 0)))
        accessibilityLabel = Strings.Trends.percentageAccessibilityLabel(
            title: titleLabel.text ?? "",
            percentage: percentageLabel.text ?? "",
            countDescription: countLabel.text ?? ""
        )
    }
}
