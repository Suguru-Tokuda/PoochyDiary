import CoreGraphics
import Foundation

struct ChartSelectionGestureState {
    private var startingSelection: Date?
    private var isActive = false
    private var hasDragged = false

    mutating func update(currentSelection: Date?, translation: CGSize) {
        if !isActive {
            startingSelection = currentSelection
            isActive = true
        }

        // Allow small finger movement during a tap, but remember any deliberate drag.
        if translation.width * translation.width + translation.height * translation.height > 64 {
            hasDragged = true
        }
    }

    mutating func shouldDismiss(endingSelection: Date?) -> Bool {
        defer { self = ChartSelectionGestureState() }
        return isActive && !hasDragged && startingSelection != nil
            && startingSelection == endingSelection
    }
}
