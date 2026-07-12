//
//  FullScreenImageView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/5/26.
//

import UIKit

class FullScreenImageView: BaseView {

  struct Model {
    let photos: [Photo]
    let startIndex: Int
  }

  var model: Model? {
    didSet {
      hasScrolledToStart = false
      applySnapshot()
    }
  }

  private typealias DataSource = UICollectionViewDiffableDataSource<Int, Photo>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Photo>

  // MARK: - Properties

  private var dataSource: DataSource?
  private var hasScrolledToStart = false

  // MARK: - UI Components

  private let collectionView: UICollectionView

  private let pageLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .themedFont(.bodyEmphasized)
    label.textAlignment = .center
    return label
  }()

  // MARK: - Init

  init() {
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: Self.makeLayout()
    )
    collectionView.backgroundColor = .black
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.contentInsetAdjustmentBehavior = .never
    super.init(frame: .zero)
  }

  @MainActor required init?(coder: NSCoder) { nil }

  // MARK: - Constructable

  override func constructView() {
    super.constructView()
    backgroundColor = .black
    collectionView.register(
      FullScreenImageViewCell.self,
      forCellWithReuseIdentifier: FullScreenImageViewCell.reuseIdentifier
    )
    collectionView.delegate = self
    dataSource = makeDataSource()
  }

  override func constructSubviews() {
    super.constructSubviews()
    addAutolayoutSubviews([
      collectionView,
      pageLabel
    ])
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

      pageLabel.bottomAnchor.constraint(
        equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.space16),
      pageLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
    ])
  }

  // MARK: - Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    guard !hasScrolledToStart,
      let model,
      collectionView.bounds.width > 0
    else { return }
    hasScrolledToStart = true
    collectionView.scrollToItem(
      at: IndexPath(item: model.startIndex, section: 0),
      at: .centeredHorizontally,
      animated: false
    )
    updatePageLabel()
  }

  // MARK: - Public (Transition support)

  /// The image currently visible in the full-screen collection view.
  /// Used by `ZoomTransitionAnimator` to snapshot the right frame during dismissal.
  var currentDisplayedImage: UIImage? {
    let pageWidth = collectionView.bounds.width
    guard pageWidth > 0 else { return nil }
    let currentPage = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
    let clamped = max(0, min(currentPage, model?.photos.count ?? 0 - 1))
    return
      (collectionView.cellForItem(at: IndexPath(item: clamped, section: 0))
      as? FullScreenImageViewCell)?.currentImage
  }

  /// The exact rendered (scaleAspectFit) rect of the image at `startIndex`, in `targetView`'s
  /// coordinate space. Call only after the view has been laid out.
  /// Pass `fallbackImageSize` when the cell's image may not be loaded yet.
  func startItemImageFrame(in targetView: UIView, fallbackImageSize: CGSize? = nil) -> CGRect? {
    itemImageFrame(
      for: model?.startIndex ?? 0, in: targetView, fallbackImageSize: fallbackImageSize)
  }

  /// The exact rendered rect of the currently visible image, in `targetView`'s coordinate space.
  func currentItemImageFrame(in targetView: UIView) -> CGRect? {
    let pageWidth = collectionView.bounds.width
    guard pageWidth > 0 else { return nil }
    let page = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
    let index = max(0, min(page, model?.photos.count ?? 0 - 1))
    return itemImageFrame(for: index, in: targetView)
  }

  // MARK: - Private helpers

  private func itemImageFrame(
    for index: Int,
    in targetView: UIView,
    fallbackImageSize: CGSize? = nil
  ) -> CGRect? {
    let indexPath = IndexPath(item: index, section: 0)
    guard let cell = collectionView.cellForItem(at: indexPath) as? FullScreenImageViewCell else {
      return nil
    }
    let imageSize = cell.currentImage?.size ?? fallbackImageSize
    guard let imageSize, imageSize.width > 0, imageSize.height > 0 else { return nil }
    let cellFrame = collectionView.convert(cell.frame, to: targetView)
    return Self.aspectFitRect(for: imageSize, in: cellFrame)
  }

  private static func aspectFitRect(for imageSize: CGSize, in containerRect: CGRect) -> CGRect {
    guard containerRect.width > 0, containerRect.height > 0 else { return containerRect }
    let imageAspect = imageSize.width / imageSize.height
    let containerAspect = containerRect.width / containerRect.height
    if imageAspect > containerAspect {
      let height = containerRect.width / imageAspect
      return CGRect(
        x: containerRect.minX,
        y: containerRect.minY + (containerRect.height - height) / 2,
        width: containerRect.width,
        height: height
      )
    } else {
      let width = containerRect.height * imageAspect
      return CGRect(
        x: containerRect.minX + (containerRect.width - width) / 2,
        y: containerRect.minY,
        width: width,
        height: containerRect.height
      )
    }
  }

  // MARK: - DataSource

  private func makeDataSource() -> DataSource {
    DataSource(collectionView: collectionView) { collectionView, indexPath, photo in
      guard
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: FullScreenImageViewCell.reuseIdentifier,
          for: indexPath
        ) as? FullScreenImageViewCell
      else { return nil }
      cell.model = FullScreenImageViewCell.Model(imageURL: photo.imageURL, image: photo.image)
      return cell
    }
  }

  private func applySnapshot() {
    guard let model, let dataSource else { return }
    var snapshot = Snapshot()
    snapshot.appendSections([0])
    snapshot.appendItems(model.photos, toSection: 0)
    dataSource.apply(snapshot, animatingDifferences: false)
  }

  // MARK: - Layout

  private static func makeLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .zero

    let config = UICollectionViewCompositionalLayoutConfiguration()
    config.scrollDirection = .horizontal
    return UICollectionViewCompositionalLayout(section: section, configuration: config)
  }

  // MARK: - Helpers

  private func updatePageLabel() {
    guard let model, model.photos.count > 1 else {
      pageLabel.isHidden = true
      return
    }
    let pageWidth = collectionView.bounds.width
    guard pageWidth > 0 else { return }
    let currentPage = Int((collectionView.contentOffset.x + pageWidth / 2) / pageWidth)
    let clamped = max(0, min(currentPage, model.photos.count - 1))
    pageLabel.text = "\(clamped + 1) / \(model.photos.count)"
  }
}

// MARK: - UICollectionViewDelegate

extension FullScreenImageView: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    updatePageLabel()
  }

  func collectionView(
    _ collectionView: UICollectionView,
    didEndDisplaying cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    if let cell = cell as? FullScreenImageViewCell {
      cell.resetZoom()
    }
  }
}
