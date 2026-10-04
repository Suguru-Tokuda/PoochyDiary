//
//  TrendsViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

final class TrendsViewController: BaseViewController {
    let viewModel: TrendsViewModel
    private var subscriptions = Set<AnyCancellable>()

    // MARK: View Properties

    private let trendTimeFramesView = TrendTimeFramesView()
    private let chartView = TrendsChartView()

    init(viewModel: TrendsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        addSubscriptions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    isolated deinit {
        removeSubscriptions()
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()

        trendTimeFramesView.onTimeFrameSelect = { [weak self] timeFrame in
            self?.viewModel.selectTimeFrame(timeFrame)
        }

        view.addAutolayoutSubviews([
            trendTimeFramesView,
            chartView
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            trendTimeFramesView.topAnchor.constraint(
                 equalTo: view.safeAreaLayoutGuide.topAnchor,
                 constant: Spacing.space20
             ),
            trendTimeFramesView.leadingAnchor.constraint(
                 equalTo: view.leadingAnchor,
                 constant: Spacing.space20
             ),
            trendTimeFramesView.trailingAnchor.constraint(
                 equalTo: view.trailingAnchor,
                 constant: -Spacing.space20
             ),
            trendTimeFramesView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: Spacing.space40 + Spacing.space4
             ),
            chartView.topAnchor.constraint(equalTo: trendTimeFramesView.bottomAnchor, constant: Spacing.space16),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupEventHandlers() {
        trendTimeFramesView.onTimeFrameSelect = { [weak self] timeFrame in
            self?.viewModel.selectTimeFrame(timeFrame)
        }
    }

    private func addSubscriptions() {
        viewModel
            .$timeFrame
            .receive(on: DispatchQueue.main)
            .sink { [weak self] timeFrame in
                self?.trendTimeFramesView.model = timeFrame
            }
            .store(in: &subscriptions)

        viewModel
            .$model
            .receive(on: DispatchQueue.main)
            .sink { [weak self] model in
                guard let self, let model else { return }

                chartView.model = TrendsChartView.Model(chartData: model.chartData)
            }
            .store(in: &subscriptions)
    }

    private func removeSubscriptions() {
        subscriptions.removeAll()
    }
}
