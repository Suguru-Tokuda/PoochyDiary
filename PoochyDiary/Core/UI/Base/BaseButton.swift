//
//  BaseButton.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/16/26.
//

import UIKit

class BaseButton: UIButton, Constructable{
    override init(frame: CGRect) {
        super.init(frame: frame)
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
