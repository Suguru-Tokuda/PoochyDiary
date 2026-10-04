import UIKit

final class TrendsWeightChartView: BaseView {
    var model: WeightChartData? {
        didSet {
            guard let model else { return }
            titleLabel.text = Strings.Trends.weightTrendTitle(unit: model.unitLabel)
            countLabel.text = Strings.Trends.weightMeasurements(count: model.measurements.count)
            chartView.model = model
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.sectionTitle)
        label.textColor = PoochyTheme.primaryText
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()

    private let chartView = WeightChartUIView()
    private let headerStack = UIStackView(axis: .vertical, distribution: .fill, spacing: Spacing.space4)

    override func constructSubviews() {
        super.constructSubviews()
        headerStack.addArrangedSubviews([titleLabel, countLabel])
        addAutolayoutSubviews([headerStack, chartView])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space20),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space20),
            chartView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: Spacing.space4),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: 0.6)
        ])
    }
}
