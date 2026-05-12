//
//  PDSelectionCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDSelectionCollectionView: UIView {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, PDSelectionItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, PDSelectionItem>

    private let collectionView: UICollectionView

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupUI() {
        collectionView.register(PDSelectionCollectionViewCell.self,
                                forCellWithReuseIdentifier: PDSelectionCollectionViewCell.reuseIdentifier)
    }
}
			
