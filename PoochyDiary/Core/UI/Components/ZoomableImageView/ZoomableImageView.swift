//
//  ZoomableImageView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/6/26.
//

import UIKit

class ZoomableImageView: BaseView {

    // MARK: - Subviews

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        return scrollView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.isUserInteractionEnabled = true
    
        return imageView
    }()

    // MARK: - Public API

    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }

    var maximumZoomScale: CGFloat = 4.0 {
        didSet { scrollView.maximumZoomScale = maximumZoomScale }
    }

    override var contentMode: UIView.ContentMode {
        get { imageView.contentMode }
        set { imageView.contentMode = newValue }
    }

    override var clipsToBounds: Bool {
        get { imageView.clipsToBounds }
        set { imageView.clipsToBounds = newValue }
    }

    // MARK: - Init

    override func constructSubviews() {
        scrollView.delegate = self
        
        addAutolayoutSubview(scrollView)
        scrollView.addAutolayoutSubview(imageView)

        setupDoubleTapToZoom()
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    // MARK: - Double tap to zoom in/out

    private func setupDoubleTapToZoom() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }

    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            let location = gesture.location(in: imageView)
            let zoomRect = zoomRect(for: 2.5, center: location)
            scrollView.zoom(to: zoomRect, animated: true)
        }
    }

    private func zoomRect(for scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(
            width: scrollView.bounds.width / scale,
            height: scrollView.bounds.height / scale
        )

        return CGRect(
            origin: CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2),
            size: size
        )
    }

    // MARK: - Reset

    func resetZoom(animated: Bool = false) {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: animated)
    }

    func setImageURL(_ imageURL: URL) {
        imageView.setImageURL(imageURL)
    }
}

extension ZoomableImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) / 2, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: offsetX)
    }
}
