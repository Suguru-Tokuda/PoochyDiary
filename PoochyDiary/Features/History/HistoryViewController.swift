//
//  HistoryViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class HistoryViewController: BaseViewController {
    let viewModel: HistoryViewModel

    // MARK: UI Components

    private let poopHistoryCollectionView = PoopHistoryCollectionView()

    init(viewModel: HistoryViewModel, onLogSelect: ((PoopLog) -> Void)?) {
        self.viewModel = viewModel
        poopHistoryCollectionView.onLogSelect = onLogSelect
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        poopHistoryCollectionView.model = PoopHistoryCollectionView.Model(items: HistoryViewModel.mockData)
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()

        view.addAutolayoutSubview(poopHistoryCollectionView)        
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            poopHistoryCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            poopHistoryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            poopHistoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space16),
            poopHistoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space16)
        ])
    }
}
