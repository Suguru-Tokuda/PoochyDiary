//
//  PDButton.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDButton: BaseButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func constructView() {
        super.constructView()
        layer.borderColor = UIColor.black.withAlphaComponent(0.8).cgColor
        layer.cornerRadius = 24
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        constructView()
    }
}
