//
//  BaseView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/11/26.
//

import UIKit

class BaseView: UIView, Constructable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    
    required init?(coder: NSCoder) {
        nil
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
