//
//  ZoomTransitionAnimator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/5/26.
//

import UIKit

// MARK: - ZoomTransitionAnimator

final class ZoomTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    enum Direction { case present, dismiss }

    var direction: Direction = .present

    /// The thumbnail cell (or any view) in window coordinates — used as the zoom source/target.
    var sourceView: UIView?

    /// Image shown in the flying snapshot during the present animation.
    var presentImage: UIImage?

    /// Image shown in the flying snapshot during the dismiss animation.
    /// Falls back to `presentImage` when nil (e.g. same photo still visible).
    var dismissImage: UIImage?

    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        0.38
    }

    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        switch direction {
        case .present: animatePresentation(transitionContext)
        case .dismiss: animateDismissal(transitionContext)
        }
    }

    // MARK: Present

    private func animatePresentation(_ context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController(forKey: .to) else {
            context.completeTransition(false)
            return
        }

        let container = context.containerView
        // Use container.bounds directly — context.finalFrame can return zero with .custom style.
        let finalFrame = container.bounds

        toVC.view.frame = finalFrame
        toVC.view.alpha = 0
        container.addSubview(toVC.view)

        // Force a layout pass so viewDidLayoutSubviews fires on the destination VC.
        // This scrolls the collection view to startIndex and makes the target cell measurable.
        toVC.view.layoutIfNeeded()

        let startFrame = sourceView.map { $0.convert($0.bounds, to: container) }
            ?? CGRect(origin: CGPoint(x: finalFrame.midX, y: finalFrame.midY), size: .zero)

        // Query the EXACT rendered rect of the image in the destination cell.
        // This accounts for safe-area insets, content-inset adjustments, and any other
        // layout quirks — so the flying snapshot lands on the pixel-perfect image position.
        let flyingTargetFrame: CGRect
        if let zoomTransitionSupport = toVC as? ZoomTransitionSupporting,
           let imageFrame = zoomTransitionSupport.startItemImageFrame(in: container,
                                                     fallbackImageSize: presentImage?.size) {
            flyingTargetFrame = imageFrame
        } else {
            flyingTargetFrame = finalFrame
        }

        let flyingView = UIImageView(image: presentImage)
        flyingView.contentMode = .scaleAspectFill
        flyingView.clipsToBounds = true
        flyingView.frame = startFrame
        container.addSubview(flyingView)

        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0.2,
            options: [.curveEaseOut]
        ) {
            flyingView.frame = flyingTargetFrame
            toVC.view.alpha = 1
        } completion: { _ in
            flyingView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }

    // MARK: Dismiss

    private func animateDismissal(_ context: UIViewControllerContextTransitioning) {
        guard let fromVC = context.viewController(forKey: .from) else {
            context.completeTransition(false)
            return
        }

        let container = context.containerView

        // Start from the exact rendered position of the currently visible image.
        let startFrame: CGRect
        if let fsVC = fromVC as? FullScreenImageViewController,
           let imageFrame = fsVC.currentItemImageFrame(in: container) {
            startFrame = imageFrame
        } else {
            startFrame = fromVC.view.frame
        }

        let endFrame = sourceView.map { $0.convert($0.bounds, to: container) }
            ?? CGRect(origin: CGPoint(x: startFrame.midX, y: startFrame.maxY), size: .zero)

        let flyingView = UIImageView(image: dismissImage ?? presentImage)
        flyingView.contentMode = .scaleAspectFill
        flyingView.clipsToBounds = true
        flyingView.frame = startFrame
        container.addSubview(flyingView)

        fromVC.view.isHidden = true

        UIView.animate(
            withDuration: transitionDuration(using: context),
            delay: 0,
            usingSpringWithDamping: 0.88,
            initialSpringVelocity: 0.2,
            options: [.curveEaseIn]
        ) {
            flyingView.frame = endFrame
            flyingView.contentMode = .scaleAspectFill
            flyingView.alpha = 0
        } completion: { _ in
            flyingView.removeFromSuperview()
            fromVC.view.isHidden = false
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}

// MARK: - FullScreenPresentationController

/// A minimal presentation controller that locks the presented view to the full container bounds.
/// Required when `modalPresentationStyle = .custom` so UIKit doesn't apply its own (potentially
/// offset) frame to the presented view after the transition animation completes.
private final class FullScreenPresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        containerView?.bounds ?? .zero
    }
}

// MARK: - ZoomTransitionDelegate

final class ZoomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let animator = ZoomTransitionAnimator()

    /// The thumbnail view that was tapped. Kept weak so it doesn't prolong cell lifetime.
    weak var sourceView: UIView?

    /// The image in the tapped thumbnail at selection time.
    var sourceImage: UIImage?

    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        animator.direction = .present
        animator.sourceView = sourceView
        animator.presentImage = sourceImage
        return animator
    }

    func animationController(
        forDismissed dismissed: UIViewController
    ) -> (any UIViewControllerAnimatedTransitioning)? {
        animator.direction = .dismiss
        // Grab the currently visible image from the full-screen VC for the dismiss snapshot
        animator.dismissImage = (dismissed as? FullScreenImageViewController)?.currentDisplayedImage
        return animator
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        // With .custom style, UIKit will call this. Return our controller so the presented
        // view is always positioned at full screen (not shifted by UIKit's default logic).
        FullScreenPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
