//
//  BaseViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/16/26.
//

import UIKit

class BaseViewController: UIViewController, Constructable {
    override func viewDidLoad() {
        super.viewDidLoad()
        construct()
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
