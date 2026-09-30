//
//  StoolDistributionChartView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 9/30/26.
//

import Charts
import SwiftUI

struct DistributionModel: Identifiable {
    let title: String
    let count: Int
    let color: Color
    
    var id: String { title }
}

struct DistributionChartView: View {
    let items: [DistributionModel]

    var total: Int {
        items.reduce(0) { $0 + $1.count }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.space20) {
            HStack(spacing: Spacing.space24) {
                Chart(items) { item in
                    SectorMark(
                        angle: .value("Count", item.count),
                        innerRadius: .ratio(0.65),
                        angularInset: 1
                    )
                    .foregroundStyle(item.color)
                }
                .chartLegend(.hidden)
                .chartBackground { _ in
                    VStack(spacing: Spacing.space4) {
                        Text("\(total)")
                            .font(.title2.bold())

                        Text("Total Poops")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 160, height: 160)

                VStack(spacing: 10) {
                    ForEach(items) { item in
                        HStack(spacing: Spacing.space8) {
                            Circle()
                                .fill(item.color)
                                .frame(width: Spacing.space8, height: Spacing.space8)

                            Text(item.title)

                            Spacer()

                            Text(percentage(for: item.count))
                                .foregroundStyle(.secondary)
                        }
                        .font(.caption)
                    }
                }
            }
        }
        .padding(Spacing.space20)
        .background(
            Color(uiColor: .secondarySystemBackground),
            in: RoundedRectangle(cornerRadius: 18)
        )
    }

    func percentage(for count: Int) -> String {
        guard total > 0 else { return "0%" }

        return (Double(count) / Double(total))
            .formatted(.percent.precision(.fractionLength(0)))
    }
}

#Preview {
    DistributionChartView(items: [
        .init(title: "Type 1", count: 1, color: .teal),
        .init(title: "Type 2", count: 2, color: .brown),
        .init(title: "Type 3", count: 4, color: .green),
        .init(title: "Type 4", count: 3, color: .purple),
        .init(title: "Type 5", count: 1, color: .red),
        .init(title: "Type 6", count: 1, color: .gray)
    ])
}
