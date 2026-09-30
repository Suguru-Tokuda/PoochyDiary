import SwiftUI
import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct DistributionChartUIViewTests {
    private func makeWindow() throws -> UIWindow {
        let scene = try #require(
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
        )
        return UIWindow(windowScene: scene)
    }

    @Test func attachesOnceAndFillsContainer() throws {
        let chart = DistributionChartUIView()
        let parent = UIViewController()
        let window = try makeWindow()
        window.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        window.rootViewController = parent
        parent.view.addSubview(chart)
        chart.frame = CGRect(x: 0, y: 0, width: 300, height: 150)
        window.isHidden = false
        defer { window.isHidden = true }

        let host = try #require(parent.children.first as? UIHostingController<DistributionChartView>)
        #expect(parent.children.count == 1)
        #expect(host.rootView.items.isEmpty)
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
        let chart = DistributionChartUIView()
        let item = DistributionModel(title: "Type 1", count: 3, color: .green)
        chart.model = [item]
        let parent = UIViewController()
        let window = try makeWindow()
        window.rootViewController = parent
        parent.view.addSubview(chart)
        window.isHidden = false
        defer { window.isHidden = true }

        let host = try #require(parent.children.first as? UIHostingController<DistributionChartView>)
        #expect(host.rootView.items.map(\.title) == [item.title])
        #expect(host.rootView.items.map(\.count) == [3])
        #expect(host.rootView.items.map(\.color) == [.green])
        let replacement = DistributionModel(title: "Type 2", count: 2, color: .red)
        chart.model = [replacement]
        #expect(host.rootView.items.map(\.title) == [replacement.title])
        #expect(host.rootView.items.map(\.count) == [2])
        #expect(host.rootView.items.map(\.color) == [.red])
        chart.model = nil
        #expect(chart.model == nil)
        #expect(host.rootView.items.map(\.title) == [replacement.title])
        chart.model = []
        #expect(host.rootView.items.isEmpty)
    }

    @Test func detachesAndReattachesToAnotherController() throws {
        let chart = DistributionChartUIView()
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
        let chart = DistributionChartUIView()
        let window = try makeWindow()
        window.addSubview(chart)
        #expect(chart.subviews.isEmpty)
    }
}
