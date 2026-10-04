import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct TrendsChartViewTests {
    @Test func chartHasContainerBoundsAndReceivesTouches() throws {
        let scene = try #require(
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        )
        let window = UIWindow(windowScene: scene)
        window.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        let controller = TrendsViewController(viewModel: TrendsViewModel())
        window.rootViewController = controller
        window.isHidden = false
        defer { window.isHidden = true }
        controller.view.layoutIfNeeded()

        let container = try #require(
            controller.view.subviews.compactMap { $0 as? TrendsChartView }.first
        )
        let chart = try #require(container.subviews.compactMap { $0 as? ChartUIView }.first)
        #expect(!container.hasAmbiguousLayout)
        #expect(container.bounds.height > 0)
        #expect(container.bounds.contains(chart.frame))

        let location = chart.convert(
            CGPoint(x: chart.bounds.midX, y: chart.bounds.midY),
            to: controller.view
        )
        let hitView = try #require(controller.view.hitTest(location, with: nil))
        #expect(hitView === chart.host.view || hitView.isDescendant(of: chart.host.view))
    }
}
