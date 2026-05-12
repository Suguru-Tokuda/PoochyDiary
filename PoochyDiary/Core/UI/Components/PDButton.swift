//
//  PDButton.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.cornerRadius = 8
        layer.borderWidth = 2
    }
}
