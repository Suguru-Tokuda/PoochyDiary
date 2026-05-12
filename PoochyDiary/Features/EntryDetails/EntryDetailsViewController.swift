//
//  EntryDetailsViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class EntryDetailsViewController: UIViewController {
    let viewModel: EntryDetailsViewModel

    init(viewModel: EntryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
