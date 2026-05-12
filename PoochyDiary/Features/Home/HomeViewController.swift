//
//  HomeViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class HomeViewController: UIViewController {
    // Closures
    var onAddLogButtonTap: (() -> Void)?
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        homeView.delegate = self
        view.addAutolayoutSubview(homeView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HomeViewController: HomeViewDelegate {
    func onAddLogPoopButtonTapped() {
        onAddLogButtonTap?()
    }
}

extension HomeViewController: NavigationBarConfigurable {
    var prefersNavigationBarHidden: Bool {
        true
    }
}
