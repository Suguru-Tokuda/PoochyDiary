import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct TrendTimeFramesViewTests {
    private func control(in view: TrendTimeFramesView) throws -> UISegmentedControl {
        try #require(view.subviews.compactMap { $0 as? UISegmentedControl }.first)
    }

    @Test func startsWithSevenDaysAndOffersThreeTimeFrames() throws {
        let view = TrendTimeFramesView()
        let control = try control(in: view)
        #expect(control.numberOfSegments == 3)
        #expect((0..<3).map { control.titleForSegment(at: $0) } == ["7 days", "30 days", "90 days"])
        #expect(control.selectedSegmentIndex == 0)
        #expect(TrendTimeFramesView.TimeFrame.allCases.map(\.rawValue) == [7, 30, 90])
    }

    @Test func titleAttributesContainUIKitFontsForBothStates() throws {
        let view = TrendTimeFramesView()
        let control = try control(in: view)
        let expectedFont = UIFont.themedFont(.cardTitle)
        for state: UIControl.State in [.normal, .selected] {
            let attributes = try #require(control.titleTextAttributes(for: state))
            // An enum stored under .font compiles but crashes during UIKit rendering.
            let font = try #require(attributes[.font] as? UIFont)
            #expect(font == expectedFont)
            let color = try #require(attributes[.foregroundColor] as? UIColor)
            #expect(color == (state == .selected ? PoochyTheme.white : PoochyTheme.primaryText))
        }
        #expect(control.selectedSegmentTintColor == PoochyTheme.accent)
    }

    @Test(arguments: [0, 1, 2])
    func selectionReportsTheCorrespondingTimeFrame(index: Int) throws {
        let view = TrendTimeFramesView()
        let control = try control(in: view)
        var selections: [TrendTimeFramesView.TimeFrame] = []
        view.onTimeFrameSelect = { selections.append($0) }
        #expect(selections.isEmpty)

        control.selectedSegmentIndex = index
        control.sendActions(for: .valueChanged)
        #expect(selections == [TrendTimeFramesView.TimeFrame.allCases[index]])
    }

    @Test func noSelectionDoesNotInvokeCallback() throws {
        let view = TrendTimeFramesView()
        let control = try control(in: view)
        var callbackCount = 0
        view.onTimeFrameSelect = { _ in callbackCount += 1 }
        control.selectedSegmentIndex = UISegmentedControl.noSegment
        control.sendActions(for: .valueChanged)
        #expect(callbackCount == 0)
    }

    @Test func selectionWithoutCallbackStillUpdatesControl() throws {
        let view = TrendTimeFramesView()
        let control = try control(in: view)
        control.selectedSegmentIndex = 2
        control.sendActions(for: .valueChanged)
        #expect(control.selectedSegmentIndex == 2)
    }

    @Test func controlIsPinnedToAllContainerEdges() throws {
        let view = TrendTimeFramesView()
        let control = try control(in: view)
        #expect(!control.translatesAutoresizingMaskIntoConstraints)
        let constraints = view.constraints.filter {
            $0.isActive && $0.firstItem === control && $0.secondItem === view
        }
        #expect(constraints.count == 4)
        for edge: NSLayoutConstraint.Attribute in [.top, .bottom, .leading, .trailing] {
            let constraint = try #require(constraints.first { $0.firstAttribute == edge })
            #expect(constraint.secondAttribute == edge)
            #expect(constraint.relation == .equal)
            #expect(constraint.constant == 0)
            #expect(constraint.multiplier == 1)
        }
    }

    @Test func trendsScreenPositionsSelectorBelowSafeArea() throws {
        let controller = TrendsViewController(viewModel: TrendsViewModel())
        controller.loadViewIfNeeded()
        controller.view.frame = CGRect(x: 0, y: 0, width: 390, height: 844)
        controller.view.layoutIfNeeded()
        let selector = try #require(
            controller.view.subviews.compactMap { $0 as? TrendTimeFramesView }.first
        )
        #expect(selector.frame.minX == Spacing.space20)
        #expect(selector.frame.maxX == controller.view.bounds.width - Spacing.space20)
        #expect(selector.frame.minY == controller.view.safeAreaLayoutGuide.layoutFrame.minY + Spacing.space20)
        #expect(selector.frame.height >= 44)
    }
}
