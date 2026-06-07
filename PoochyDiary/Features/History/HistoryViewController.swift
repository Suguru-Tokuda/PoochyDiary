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

    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
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

    override func constructSubviews() {
        super.constructSubviews()

        view.addAutolayoutSubview(poopHistoryCollectionView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            poopHistoryCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            poopHistoryCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            poopHistoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            poopHistoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
