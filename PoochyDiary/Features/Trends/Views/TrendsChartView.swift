//
//  TrendsChartView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 10/3/26.
//

import UIKit

class TrendsChartView: BaseView {
    struct Model {
        let chartData: ChartData
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    // MARK: - UI Elements

    private let titleLabel = PDLabel(model: PDLabel.Model(title: "Events", isOptional: false))
    private let chartView = ChartUIView()

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            titleLabel,
            chartView
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            chartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            chartView.heightAnchor.constraint(
                equalTo: chartView.widthAnchor, multiplier: 0.5)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        chartView.model = model.chartData
    }
}
