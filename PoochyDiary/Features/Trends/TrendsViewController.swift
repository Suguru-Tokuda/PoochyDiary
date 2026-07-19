//
//  TrendsViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class TrendsViewController: BaseViewController {
    let viewModel: TrendsViewModel

    init(viewModel: TrendsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = PoochyTheme.background
    }
}
