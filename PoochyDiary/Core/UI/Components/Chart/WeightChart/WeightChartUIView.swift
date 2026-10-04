import SwiftUI
import UIKit

final class WeightChartUIView: BaseSwiftUIConversionView<WeightChartView> {
    var model: WeightChartData? {
        didSet {
            guard let model else { return }
            host.rootView = WeightChartView(data: model)
        }
    }

    init() {
        super.init(rootView: WeightChartView(data: .empty))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
}
