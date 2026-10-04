import UIKit

final class TrendsSummaryView: BaseView {
    private(set) var isExpanded = false
    private var weightPaddingConstraints: [NSLayoutConstraint] = []

    var model: TrendsSummary? {
        didSet { applyModel() }
    }

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

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.Trends.summary
        label.font = .themedFont(.sectionTitle)
        label.textColor = PoochyTheme.primaryText
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.textAlignment = .right
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private let detailsButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.title = Strings.Trends.showDetails
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = Spacing.space4
        configuration.baseForegroundColor = PoochyTheme.accent
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Spacing.space8, leading: 0, bottom: Spacing.space8, trailing: 0
        )
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attributes in
            var attributes = attributes
            attributes.font = .themedFont(.captionEmphasized)
            return attributes
        }
        button.configuration = configuration
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let percentageStack: UIStackView = UIStackView(
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: Spacing.space12
    )

    private let bloodCard: TrendsPercentageCardView = {
        TrendsPercentageCardView(title: Strings.Trends.bloodObserved, color: .systemRed)
    }()

    private let mucusCard: TrendsPercentageCardView = {
        TrendsPercentageCardView(title: Strings.Trends.mucusObserved, color: .systemPurple)
    }()

    private let metricsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.surface
        view.layer.cornerRadius = Spacing.space16
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let metricsStack: UIStackView = UIStackView(
        axis: .horizontal,
        distribution: .fillEqually
    )

    private let totalMetric: TrendsSummaryMetricView = {
        TrendsSummaryMetricView(title: Strings.Trends.totalPoops, showsDivider: true)
    }()

    private let averageMetric: TrendsSummaryMetricView = {
        TrendsSummaryMetricView(title: Strings.Trends.dailyAverage, showsDivider: true)
    }()

    private let daysMetric: TrendsSummaryMetricView = {
        TrendsSummaryMetricView(title: Strings.Trends.daysLogged, showsDivider: false)
    }()

    private let explanationLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.Trends.percentageExplanation
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let weightMetricsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.surface
        view.layer.cornerRadius = Spacing.space16
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let weightMetricsStack = UIStackView(
        axis: .horizontal,
        distribution: .fillEqually
    )

    private let currentWeightMetric: TrendsSummaryMetricView = {
        TrendsSummaryMetricView(title: Strings.Trends.currentWeight, showsDivider: true)
    }()

    private let averageWeightMetric: TrendsSummaryMetricView = {
        TrendsSummaryMetricView(title: Strings.Trends.averageWeight, showsDivider: false)
    }()

    private let weightExplanationLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.Trends.weightAverageExplanation
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let dateFormatter: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateTemplate = "MMMd"
        return formatter
    }()

    override func constructView() {
        registerForTraitChanges(
            [UITraitPreferredContentSizeCategory.self]
        ) { (view: TrendsSummaryView, _: UITraitCollection) in
            view.updateLayoutForTextSize()
        }
        updateLayoutForTextSize()
    }

    override func constructSubviews() {
        headerStack.addArrangedSubviews([titleLabel, dateLabel, detailsButton])
        percentageStack.addArrangedSubviews([bloodCard, mucusCard])
        metricsStack.addArrangedSubviews([totalMetric, averageMetric, daysMetric])
        metricsContainer.addAutolayoutSubview(metricsStack)
        weightMetricsStack.addArrangedSubviews([currentWeightMetric, averageWeightMetric])
        weightMetricsContainer.addAutolayoutSubview(weightMetricsStack)
        contentStack.addArrangedSubviews([
            headerStack, percentageStack, metricsContainer, explanationLabel,
            weightMetricsContainer, weightExplanationLabel
        ])
        addAutolayoutSubview(contentStack)
        detailsButton.addTarget(self, action: #selector(toggleDetails), for: .touchUpInside)
        updateDisplayState()
    }

    override func constructSubviewLayoutConstraints() {
        weightPaddingConstraints = [
            weightMetricsStack.topAnchor.constraint(
                equalTo: weightMetricsContainer.topAnchor, constant: Spacing.space8
            ),
            weightMetricsStack.bottomAnchor.constraint(
                equalTo: weightMetricsContainer.bottomAnchor, constant: -Spacing.space8
            )
        ]
        NSLayoutConstraint.activate(weightPaddingConstraints)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space20),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space20),
            metricsStack.topAnchor.constraint(equalTo: metricsContainer.topAnchor, constant: Spacing.space16),
            metricsStack.bottomAnchor.constraint(equalTo: metricsContainer.bottomAnchor, constant: -Spacing.space16),
            metricsStack.leadingAnchor.constraint(equalTo: metricsContainer.leadingAnchor, constant: Spacing.space8),
            metricsStack.trailingAnchor.constraint(equalTo: metricsContainer.trailingAnchor, constant: -Spacing.space8),
            detailsButton.heightAnchor.constraint(greaterThanOrEqualToConstant: Spacing.space40 + Spacing.space4),
            weightMetricsStack.leadingAnchor.constraint(
                equalTo: weightMetricsContainer.leadingAnchor, constant: Spacing.space8
            ),
            weightMetricsStack.trailingAnchor.constraint(
                equalTo: weightMetricsContainer.trailingAnchor, constant: -Spacing.space8
            )
        ])
        updateDisplayState()
    }

    func setExpanded(_ expanded: Bool) {
        isExpanded = expanded
        updateDisplayState()
    }

    @objc private func toggleDetails() {
        setExpanded(!isExpanded)
    }

    private func updateDisplayState() {
        bloodCard.setExpanded(isExpanded)
        mucusCard.setExpanded(isExpanded)
        let detailViews = [metricsContainer, explanationLabel, weightExplanationLabel]
        if isExpanded {
            if metricsContainer.superview !== contentStack {
                contentStack.insertArrangedSubview(metricsContainer, at: 2)
                contentStack.insertArrangedSubview(explanationLabel, at: 3)
                contentStack.addArrangedSubview(weightExplanationLabel)
            }
        } else {
            detailViews.forEach {
                contentStack.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
        }
        weightPaddingConstraints.first?.constant = isExpanded ? Spacing.space16 : Spacing.space8
        weightPaddingConstraints.last?.constant = isExpanded ? -Spacing.space16 : -Spacing.space8
        detailsButton.configuration?.title = isExpanded ? Strings.Trends.hideDetails : Strings.Trends.showDetails
        detailsButton.configuration?.image = UIImage(systemName: isExpanded ? "chevron.up" : "chevron.down")
    }

    private func updateLayoutForTextSize() {
        let largeText = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        headerStack.axis = largeText ? .vertical : .horizontal
        headerStack.alignment = largeText ? .leading : .center
        dateLabel.textAlignment = largeText ? .left : .right
        percentageStack.axis = largeText ? .vertical : .horizontal
        percentageStack.distribution = largeText ? .fill : .fillEqually
        metricsStack.axis = largeText ? .vertical : .horizontal
        metricsStack.distribution = largeText ? .fill : .fillEqually
        metricsStack.spacing = largeText ? Spacing.space16 : 0
        totalMetric.setDividerHidden(largeText)
        averageMetric.setDividerHidden(largeText)
        weightMetricsStack.axis = largeText ? .vertical : .horizontal
        weightMetricsStack.distribution = largeText ? .fill : .fillEqually
        weightMetricsStack.spacing = largeText ? Spacing.space16 : 0
        currentWeightMetric.setDividerHidden(largeText)
    }

    private func applyModel() {
        guard let model else { return }
        if let start = model.startDate, let end = model.endDate {
            dateLabel.text = dateFormatter.string(from: start, to: end)
        } else {
            dateLabel.text = Strings.Trends.noDatesLogged
        }
        bloodCard.update(fraction: model.bloodFraction, count: model.bloodCount, total: model.totalPoops)
        mucusCard.update(fraction: model.mucusFraction, count: model.mucusCount, total: model.totalPoops)
        totalMetric.update(value: model.totalPoops.formatted())
        averageMetric.update(value: model.averagePerDay.formatted(.number.precision(.fractionLength(1))))
        daysMetric.update(value: Strings.Trends.daysLoggedValue(logged: model.daysLogged, total: model.totalDays))
        currentWeightMetric.update(value: model.weightData.formattedWeight(model.weightData.currentWeight))
        averageWeightMetric.update(value: model.weightData.formattedWeight(model.weightData.averageWeight))
    }
}
