//
//  TrendsViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

final class TrendsViewController: BaseViewController {
    var onPetSelectorTap: (() -> Void)?

    let viewModel: TrendsViewModel
    private var subscriptions = Set<AnyCancellable>()

    // MARK: View Properties

    private let headerView = HeaderView(title: Strings.Tabs.trends)
    private let trendTimeFramesView = TrendTimeFramesView()
    private let chartView = TrendsChartView()
    private let weightChartView = TrendsWeightChartView()
    private let summaryView = TrendsSummaryView()
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        return view
    }()

    private let contentStack: UIStackView = UIStackView(
        axis: .vertical,
        distribution: .fill,
        spacing: Spacing.space24
    )

    init(viewModel: TrendsViewModel) {
        self.viewModel = viewModel
        headerView.petName = viewModel.pet?.name
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = PoochyTheme.background
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()

        setupEventHandlers()

        view.addAutolayoutSubviews([
            headerView,
            trendTimeFramesView,
            scrollView
        ])
        scrollView.addAutolayoutSubview(contentStack)
        contentStack.addArrangedSubviews([summaryView, chartView, weightChartView])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space20),
            trendTimeFramesView.topAnchor.constraint(
                 equalTo: headerView.bottomAnchor,
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
            scrollView.topAnchor.constraint(equalTo: trendTimeFramesView.bottomAnchor, constant: Spacing.space16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Spacing.space24
            ),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func setupEventHandlers() {
        headerView.onPetSelectorTap = { [weak self] in
            self?.onPetSelectorTap?()
        }
        trendTimeFramesView.onTimeFrameSelect = { [weak self] timeFrame in
            self?.viewModel.selectTimeFrame(timeFrame)
        }
    }

    private func addSubscriptions() {
        viewModel
            .$pet
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pet in
                self?.headerView.petName = pet?.name
            }
            .store(in: &subscriptions)

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

                chartView.model = TrendsChartView.Model(
                    chartData: model.chartData,
                    totalPoops: model.summary.totalPoops
                )
                summaryView.model = model.summary
                weightChartView.model = model.weightChartData
            }
            .store(in: &subscriptions)
    }

    private func removeSubscriptions() {
        subscriptions.removeAll()
    }
}
