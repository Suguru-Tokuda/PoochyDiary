//
//  PDImageCarouselView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/5/26.
//

import UIKit

class PDImageCarouselView: BaseView {
  nonisolated private struct PhotoWrapper: Hashable {
    let copyIndex: Int
    let photo: Photo
  }

  struct Model {
    let photos: [Photo]
  }

  struct Configuration {
    enum Style: Equatable {
      case carousel
      case thumbnails(size: CGFloat, spacing: CGFloat, sectionInset: CGFloat)
    }

    let style: Style

    static let `default` = Configuration(style: .carousel)
    static let thumbnails = Configuration(
      style: .thumbnails(
        size: Spacing.space48 * 2,
        spacing: Spacing.space8,
        sectionInset: Spacing.space16)
    )
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  /// Called with the index into the original `photos` array when a cell is tapped.
  var onPhotoSelect: ((Int, UIView) -> Void)?

  private typealias DataSource = UICollectionViewDiffableDataSource<Int, PhotoWrapper>
  private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, PhotoWrapper>

  private let configuration: Configuration
  private let collectionView: UICollectionView
  private var dataSource: DataSource?

  init(configuration: Configuration = .default) {
    self.configuration = configuration
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: Self.makeLayout(configuration: configuration)
    )
    super.init(frame: .zero)
  }

  override init(frame: CGRect) {
    configuration = .default
    collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: Self.makeLayout(configuration: .default)
    )
    super.init(frame: frame)
  }

  @MainActor required init?(coder: NSCoder) {
    nil
  }

  override func constructView() {
    super.constructView()
    dataSource = makeDataSource()
    collectionView.register(
      PDImageCarouselViewCell.self,
      forCellWithReuseIdentifier: PDImageCarouselViewCell.reuseIdentifer
    )
    collectionView.backgroundColor = .clear
    collectionView.delegate = self

    switch configuration.style {
    case .carousel:
      collectionView.showsHorizontalScrollIndicator = false
    case .thumbnails:
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.showsVerticalScrollIndicator = false
    }
  }

  override func constructSubviews() {
    super.constructSubviews()
    addAutolayoutSubview(collectionView)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  private func makeDataSource() -> DataSource {
    DataSource(collectionView: collectionView) {
      [weak self] collectionView, indexPath, itemIdentifier in
      guard let self,
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PDImageCarouselViewCell.reuseIdentifer,
          for: indexPath
        ) as? PDImageCarouselViewCell
      else {
        return nil
      }

      switch configuration.style {
      case .carousel:
        cell.contentView.clipsToBounds = false
      case .thumbnails:
        cell.contentView.clipsToBounds = true
      }

      cell.model = PDImageCarouselViewCell.Model(
        imageURL: itemIdentifier.photo.imageURL,
        image: itemIdentifier.photo.image
      )
      return cell
    }
  }

  private static func makeLayout(configuration: Configuration) -> UICollectionViewLayout {
    switch configuration.style {
    case .carousel:
      return UICollectionViewCompositionalLayout { _, _ in
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
        section.orthogonalScrollingBehavior = .groupPaging
        return section
      }

    case .thumbnails(let size, let spacing, let sectionInset):
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .absolute(size),
        heightDimension: .fractionalHeight(1.0)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

      let groupSize = NSCollectionLayoutSize(
        widthDimension: .absolute(size),
        heightDimension: .fractionalHeight(1.0)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = spacing
      section.contentInsets = NSDirectionalEdgeInsets(
        top: 0, leading: sectionInset, bottom: 0, trailing: sectionInset
      )

      let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
      layoutConfig.scrollDirection = .horizontal
      return UICollectionViewCompositionalLayout(section: section, configuration: layoutConfig)
    }
  }

  private func applyModel() {
    let photos = model?.photos ?? []
    applySnapshot(photos: photos)
  }

  private func applySnapshot(photos: [Photo]) {
    guard let dataSource, !photos.isEmpty else { return }

    var snapshot = Snapshot()
    snapshot.appendSections([0])

    switch configuration.style {
    case .carousel:
      let repeatCount = photos.count == 1 ? 1 : 100
      let repeated = (0..<repeatCount).flatMap { copyIndex in
        photos.map { PhotoWrapper(copyIndex: copyIndex, photo: $0) }
      }
      snapshot.appendItems(repeated, toSection: 0)
      dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
        guard let self else { return }
        let startIndex = photos.count * (repeatCount / 2)
        collectionView.scrollToItem(
          at: IndexPath(item: startIndex, section: 0),
          at: .centeredHorizontally,
          animated: false
        )
      }

    case .thumbnails:
      let items = photos.map { PhotoWrapper(copyIndex: 0, photo: $0) }
      snapshot.appendItems(items, toSection: 0)
      dataSource.apply(snapshot, animatingDifferences: false)
    }
  }
}

extension PDImageCarouselView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let photos = model?.photos, !photos.isEmpty,
      let cell = collectionView.cellForItem(at: indexPath)
    else { return }
    let index: Int
    switch configuration.style {
    case .carousel:
      index = indexPath.item % photos.count
    case .thumbnails:
      index = indexPath.item
    }
    onPhotoSelect?(index, cell)
  }
}
