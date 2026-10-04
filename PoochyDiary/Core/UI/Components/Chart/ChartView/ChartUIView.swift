//
//  ChartUIView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 9/24/26.
//

import UIKit
import SwiftUI

final class ChartUIView: BaseSwiftUIConversionView<ChartView> {
    init() {
        super.init(rootView: ChartView(data: ChartData(dataSet: [])))
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: ChartData? {
        didSet {
            applyModel()
        }
    }

    private func applyModel() {
        guard let model else { return }
        host.rootView = ChartView(data: model)
    }
}
