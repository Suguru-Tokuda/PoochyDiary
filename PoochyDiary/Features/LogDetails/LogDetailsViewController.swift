//
//  LogDetailsViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import Combine
import UIKit

protocol LogDetailsViewControllerDelegate: AnyObject {
    func logDetailsViewController(
        _ viewController: LogDetailsViewController,
        didSelectPhotoAt index: Int,
        sourceView: UIView,
        photos: [Photo]
    )
}

class LogDetailsViewController: BaseViewController {
    private let viewModel: LogDetailsViewModel
    private var subscriptions = Set<AnyCancellable>()

    weak var delegate: LogDetailsViewControllerDelegate?

    // MARK: - UIComponents

    private let logDetailsView = LogDetailsView()

    init(viewModel: LogDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubscriptions()
        view.backgroundColor = .systemBackground

        logDetailsView.onPhotoSelect = { [weak self] index, sourceView in
            guard let self else { return }
            let photos = viewModel.state.log.photos
            delegate?.logDetailsViewController(self, didSelectPhotoAt: index, sourceView: sourceView, photos: photos)
        }
    }

    override func constructSubviews() {
        super.constructSubviews()
        view.addAutolayoutSubview(logDetailsView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            logDetailsView.topAnchor.constraint(equalTo: view.topAnchor),
            logDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            logDetailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logDetailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func addSubscriptions() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.logDetailsView.model = LogDetailsView.Model(
                    pet: state.pet,
                    log: state.log
                )
            }
            .store(in: &subscriptions)
    }
}
