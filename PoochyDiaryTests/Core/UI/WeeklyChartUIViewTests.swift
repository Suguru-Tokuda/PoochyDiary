import SwiftUI
import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct ChartUIViewTests {
    @Test func rebuildingSeriesPreservesIdentityForAnimation() {
        let date = Date(timeIntervalSince1970: 0)
        let original = ChartGroup(
            legendTitle: "Poops", data: [DailyCount(date: date, count: 1)], color: .green
        )
        let updated = ChartGroup(
            legendTitle: "Poops", data: [DailyCount(date: date, count: 3)], color: .green
        )
        #expect(original.id == updated.id)
        #expect(original.data.first?.id == updated.data.first?.id)
        #expect(ChartData(dataSet: [original]) != ChartData(dataSet: [updated]))
    }

    private func makeWindow() throws -> UIWindow {
        let scene = try #require(
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        )
        return UIWindow(windowScene: scene)
    }

    @Test func attachesOnceAndFillsContainer() throws {
        let chart = ChartUIView()
        let parent = UIViewController()
        let window = try makeWindow()
        window.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        window.rootViewController = parent
        parent.view.addSubview(chart)
        chart.frame = CGRect(x: 0, y: 0, width: 300, height: 150)
        window.isHidden = false
        defer { window.isHidden = true }

        let host = try #require(parent.children.first as? UIHostingController<ChartView>)
        #expect(parent.children.count == 1)
        #expect(host.view.superview === chart)
        #expect(host.view.backgroundColor == .clear)
        chart.layoutIfNeeded()
        #expect(host.view.frame == chart.bounds)
        chart.didMoveToWindow()
        #expect(parent.children.count == 1)
        #expect(chart.subviews.count == 1)
        #expect(chart.constraints.filter(\.isActive).count == 4)
    }

    @Test func updatesHostedDataAndPreservesItWhenModelIsNil() throws {
        let chart = ChartUIView()
        let group = ChartGroup(legendTitle: "Poops", data: [
            DailyCount(date: Date(timeIntervalSince1970: 0), count: 3)
        ], color: .green)
        chart.model = ChartData(dataSet: [group])
        let parent = UIViewController()
        let window = try makeWindow()
        window.rootViewController = parent
        parent.view.addSubview(chart)
        window.isHidden = false
        defer { window.isHidden = true }

        let host = try #require(parent.children.first as? UIHostingController<ChartView>)
        #expect(host.rootView.data.dataSet.map(\.id) == [group.id])
        let replacement = ChartGroup(legendTitle: "Blood", data: [], color: .red)
        chart.model = ChartData(dataSet: [replacement])
        #expect(host.rootView.data.dataSet.map(\.id) == [replacement.id])
        chart.model = nil
        #expect(chart.model == nil)
        #expect(host.rootView.data.dataSet.map(\.id) == [replacement.id])
    }

    @Test func detachesAndReattachesToAnotherController() throws {
        let chart = ChartUIView()
        let first = UIViewController()
        let window = try makeWindow()
        window.rootViewController = first
        first.view.addSubview(chart)
        window.isHidden = false
        defer { window.isHidden = true }
        let host = try #require(first.children.first)

        chart.removeFromSuperview()
        #expect(first.children.isEmpty)
        #expect(host.parent == nil)
        #expect(chart.subviews.isEmpty)

        let second = UIViewController()
        window.rootViewController = second
        second.view.addSubview(chart)
        #expect(second.children.count == 1)
        #expect(second.children.first === host)
        #expect(host.view.superview === chart)
    }

    @Test func windowWithoutControllerDoesNotAttachHost() throws {
        let chart = ChartUIView()
        let window = try makeWindow()
        window.addSubview(chart)
        #expect(chart.subviews.isEmpty)
    }
}
