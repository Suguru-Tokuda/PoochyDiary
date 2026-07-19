//
//  PDButton.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDButton: BaseButton {
    override func constructView() {
        super.constructView()
        layer.borderColor = PoochyTheme.black.withAlphaComponent(0.8).cgColor
        layer.cornerRadius = 24
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        constructView()
    }
}
