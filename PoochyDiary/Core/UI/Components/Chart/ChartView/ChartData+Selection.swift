import Foundation
import SwiftUI

extension ChartData {
    struct SelectedValue: Identifiable {
        let legendTitle: String
        let count: Int
        let color: Color

        var id: String { legendTitle }
    }

    struct Selection {
        let date: Date
        let values: [SelectedValue]
    }

    func selection(nearestTo date: Date) -> Selection? {
        let dates = Set(dataSet.flatMap(\.data).map(\.date))
        guard let nearestDate = dates.min(by: { lhs, rhs in
            let lhsDistance = abs(lhs.timeIntervalSince(date))
            let rhsDistance = abs(rhs.timeIntervalSince(date))
            return lhsDistance == rhsDistance ? lhs < rhs : lhsDistance < rhsDistance
        }) else {
            return nil
        }

        let values = dataSet.compactMap { group -> SelectedValue? in
            guard let point = group.data.first(where: { $0.date == nearestDate }) else {
                return nil
            }
            return SelectedValue(
                legendTitle: group.legendTitle,
                count: point.count,
                color: group.color
            )
        }
        return Selection(date: nearestDate, values: values)
    }
}
