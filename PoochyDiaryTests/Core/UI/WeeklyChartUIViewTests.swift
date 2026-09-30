import SwiftUI
import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct WeeklyChartUIViewTests {
    @Test func attachesOnceAndFillsContainer() throws {
        let chart = WeeklyChartUIView()
        let parent = UIViewController()
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 390, height: 844))
        window.rootViewController = parent
        parent.view.addSubview(chart)
        chart.frame = CGRect(x: 0, y: 0, width: 300, height: 150)
        window.isHidden = false
        defer { window.isHidden = true }

        let host = try #require(parent.children.first as? UIHostingController<WeeklyChartView>)
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

    @Test func updatesHostedDataAndClearsItWhenNil() throws {
        let chart = WeeklyChartUIView()
        let group = ChartGroup(legendTitle: "Poops", data: [
            DailyCount(date: Date(timeIntervalSince1970: 0), count: 3)
        ], color: .green)
        chart.data = WeeklyChartData(dataSet: [group])
        let parent = UIViewController()
        let window = UIWindow()
        window.rootViewController = parent
        parent.view.addSubview(chart)
        window.isHidden = false
        defer { window.isHidden = true }

        let host = try #require(parent.children.first as? UIHostingController<WeeklyChartView>)
        #expect(host.rootView.data.dataSet.map(\.id) == [group.id])
        let replacement = ChartGroup(legendTitle: "Blood", data: [], color: .red)
        chart.data = WeeklyChartData(dataSet: [replacement])
        #expect(host.rootView.data.dataSet.map(\.id) == [replacement.id])
        chart.data = nil
        #expect(host.rootView.data.dataSet.isEmpty)
    }

    @Test func detachesAndReattachesToAnotherController() throws {
        let chart = WeeklyChartUIView()
        let first = UIViewController()
        let window = UIWindow()
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

    @Test func windowWithoutControllerDoesNotAttachHost() {
        let chart = WeeklyChartUIView()
        let window = UIWindow()
        window.addSubview(chart)
        #expect(chart.subviews.isEmpty)
    }
}
