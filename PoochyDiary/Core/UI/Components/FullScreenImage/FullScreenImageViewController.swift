//
//  FullScreenImageViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/5/26.
//

import UIKit

class FullScreenImageViewController: BaseViewController {

    // MARK: - UI Components

    private let fullScreenImageView = FullScreenImageView()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 16
        return button
    }()

    // MARK: - Properties

    private let viewModel: FullScreenImageViewModel

    // MARK: - Init

    init(viewModel: FullScreenImageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }

    @MainActor required init?(coder: NSCoder) { nil }

    // MARK: - Constructable

    override func constructView() {
        super.constructView()
        view.backgroundColor = .black
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)

        let dismissPan = UIPanGestureRecognizer(target: self, action: #selector(handleDismissPan))
        dismissPan.delegate = self
        view.addGestureRecognizer(dismissPan)
    }

    override func constructSubviews() {
        super.constructSubviews()
        view.addAutolayoutSubviews([
            fullScreenImageView,
            closeButton
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            fullScreenImageView.topAnchor.constraint(equalTo: view.topAnchor),
            fullScreenImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            fullScreenImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullScreenImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            closeButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Spacing.space12),
            closeButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -Spacing.space16),
            closeButton.widthAnchor.constraint(equalToConstant: Spacing.space32),
            closeButton.heightAnchor.constraint(equalToConstant: Spacing.space32)
        ])
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenImageView.model = FullScreenImageView.Model(
            photos: viewModel.photos,
            startIndex: viewModel.startIndex
        )
    }

    // MARK: - Actions

    @objc private func closeTapped() {
        dismiss(animated: true)
    }

    @objc private func handleDismissPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)

        switch gesture.state {
        case .changed:
            guard translation.y > 0 else { return }
            view.transform = CGAffineTransform(translationX: 0, y: translation.y)
            view.alpha = max(0.5, 1 - translation.y / 400)
        case .ended, .cancelled:
            if translation.y > 150 || velocity.y > 800 {
                // The view is already visually dismissed via the pan — skip the animator.
                dismiss(animated: false)
            } else {
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0,
                    options: [],
                    animations: {
                        self.view.transform = .identity
                        self.view.alpha = 1
                    }
                )
            }
        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension FullScreenImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        let velocity = pan.velocity(in: view)
        return velocity.y > 0 && abs(velocity.y) > abs(velocity.x)
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

// MARK: ZoomTransitionSupporting

extension FullScreenImageViewController: ZoomTransitionSupporting {
    var currentDisplayedImage: UIImage? {
        fullScreenImageView.currentDisplayedImage
    }

    func startItemImageFrame(in targetView: UIView, fallbackImageSize: CGSize? = nil) -> CGRect? {
        fullScreenImageView.startItemImageFrame(
            in: targetView, fallbackImageSize: fallbackImageSize)
    }

    func currentItemImageFrame(in targetView: UIView) -> CGRect? {
        fullScreenImageView.currentItemImageFrame(in: targetView)
    }
}
