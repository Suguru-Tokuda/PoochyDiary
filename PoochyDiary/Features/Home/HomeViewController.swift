//
//  HomeViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class HomeViewController: BaseViewController {
    // Closures
    var onAddDiaryButtonTap: (() -> Void)?
    let viewModel: HomeViewModel
    let homeView = HomeView()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func constructSubviews() {
        super.constructSubviews()
        homeView.delegate = self
        homeView.model = .mock(petName: viewModel.activePet.name)
        view.addAutolayoutSubview(homeView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HomeViewController: HomeViewDelegate {
    func onAddDiaryEntryButtonTapped() {
        onAddDiaryButtonTap?()
    }
}

extension HomeViewController: NavigationBarConfigurable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}
