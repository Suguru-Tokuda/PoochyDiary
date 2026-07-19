//
//  ProfileViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class ProfileViewController: BaseViewController {
    let viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = .accent
    }
}
