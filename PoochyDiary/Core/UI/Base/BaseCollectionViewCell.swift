//
//  BaseCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/12/26.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func construct() {
        constructView()
        constructSubviews()
        constructSubviewLayoutConstraints()
    }
    
    func constructView() {}
    func constructSubviews() {}
    func constructSubviewLayoutConstraints() {}
}
