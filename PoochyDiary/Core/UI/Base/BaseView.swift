//
//  BaseView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/11/26.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructView()
        constructSubviews()
        constructSubviewLayoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    func constructView() {}
    func constructSubviews() {}
    func constructSubviewLayoutConstraints() {}
}
