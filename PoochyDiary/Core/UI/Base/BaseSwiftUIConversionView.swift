//
//  BaseSwiftUIConversionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 10/1/26.
//

import UIKit
import SwiftUI

class BaseSwiftUIConversionView<T: View>: BaseView {
    let host: UIHostingController<T>

    init(rootView: T) {
        host = UIHostingController(
            rootView: rootView
        )
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("Use init()")
    }

    private var containingViewController: UIViewController? {
        var responder: UIResponder? = next

        while let current = responder {
            if let controller = current as? UIViewController {
                return controller
            }

            responder = current.next
        }

        return nil
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()

        guard window != nil else {
            detach()
            return
        }

        guard let parent = containingViewController,
              host.parent !== parent else {
            return
        }

        detach()
        parent.addChild(host)

        guard let hostedView = host.view else {
            detach()
            return
        }

        hostedView.backgroundColor = .clear
        addAutolayoutSubview(hostedView)
        NSLayoutConstraint.activate([
            hostedView.topAnchor.constraint(equalTo: topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hostedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        host.didMove(toParent: parent)
    }

    private func detach() {
        guard host.parent != nil else { return }

        host.willMove(toParent: nil)
        host.view.removeFromSuperview()
        host.removeFromParent()
    }
}
