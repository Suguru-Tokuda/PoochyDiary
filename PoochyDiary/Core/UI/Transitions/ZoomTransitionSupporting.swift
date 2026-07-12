//
//  ZoomTransitionSupporting.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/5/26.
//

import UIKit

protocol ZoomTransitionSupporting {
    var currentDisplayedImage: UIImage? { get }
    func startItemImageFrame(in targetView: UIView, fallbackImageSize: CGSize?) -> CGRect?
    func currentItemImageFrame(in targetView: UIView) -> CGRect?
}
