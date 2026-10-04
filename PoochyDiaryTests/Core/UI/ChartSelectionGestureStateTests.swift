import CoreGraphics
import Foundation
import Testing

@testable import PoochyDiary

@MainActor
struct ChartSelectionGestureStateTests {
    private let date = Date(timeIntervalSince1970: 0)

    @Test func firstTapShowsCardAndSecondTapOnSameDateDismissesIt() {
        var gesture = ChartSelectionGestureState()
        gesture.update(currentSelection: nil, translation: .zero)
        gesture.update(currentSelection: date, translation: .zero)
        let dismissFirstTap = gesture.shouldDismiss(endingSelection: date)
        #expect(!dismissFirstTap)

        gesture.update(currentSelection: date, translation: .zero)
        let dismissSecondTap = gesture.shouldDismiss(endingSelection: date)
        #expect(dismissSecondTap)
    }

    @Test func tappingAnotherDateKeepsCardVisible() {
        var gesture = ChartSelectionGestureState()
        gesture.update(currentSelection: date, translation: .zero)
        let dismiss = gesture.shouldDismiss(endingSelection: date.addingTimeInterval(86_400))
        #expect(!dismiss)
    }

    @Test func smallFingerMovementStillCountsAsTap() {
        var gesture = ChartSelectionGestureState()
        gesture.update(currentSelection: date, translation: CGSize(width: 2, height: 3))
        let dismiss = gesture.shouldDismiss(endingSelection: date)
        #expect(dismiss)
    }

    @Test func draggingBackToSameDateDoesNotDismissCard() {
        var gesture = ChartSelectionGestureState()
        gesture.update(currentSelection: date, translation: .zero)
        gesture.update(currentSelection: date.addingTimeInterval(86_400), translation: CGSize(width: 20, height: 0))
        gesture.update(currentSelection: date, translation: .zero)
        let dismiss = gesture.shouldDismiss(endingSelection: date)
        #expect(!dismiss)
    }

    @Test func finishingGestureResetsItsDragHistory() {
        var gesture = ChartSelectionGestureState()
        gesture.update(currentSelection: date, translation: CGSize(width: 0, height: 20))
        let dismissDrag = gesture.shouldDismiss(endingSelection: date)
        #expect(!dismissDrag)
        gesture.update(currentSelection: date, translation: .zero)
        let dismissTap = gesture.shouldDismiss(endingSelection: date)
        #expect(dismissTap)
    }
}
