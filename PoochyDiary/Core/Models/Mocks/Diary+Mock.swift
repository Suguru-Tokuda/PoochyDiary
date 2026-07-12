//
//  Diary+Mock.swift
//  PoochyDiary
//
//  Created by Codex on 7/12/26.
//

#if DEBUG
import Foundation

extension Diary {
    private struct SeededGenerator: RandomNumberGenerator {
        private var state: UInt64

        init(seed: UInt64) {
            state = seed
        }

        mutating func next() -> UInt64 {
            state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
            return state
        }
    }

    // Generates roughly six months of stable fixture data.
    // swiftlint:disable:next function_body_length
    static func mockData() -> [Diary] {
        var generator = SeededGenerator(seed: 20_260_711)
        let calendar = Calendar.current
        let petId = UUID()
        let today = calendar.startOfDay(for: Date())
        let totalDays = 183
        let oldestDay = calendar.date(byAdding: .day, value: -(totalDays - 1), to: today)!

        let stoolWeights: [(StoolType, Int)] = [
            (.normal, 40), (.firm, 25), (.soft, 20), (.mushy, 8), (.extraFirm, 4), (.watery, 3)
        ]
        let mucusWeights: [(MucusLevel, Int)] = [
            (.none, 70), (.trace, 15), (.mild, 10), (.moderate, 4), (.heavy, 1)
        ]
        let bloodWeights: [(BloodAmount, Int)] = [
            (.none, 80), (.speck, 10), (.streak, 6), (.moderate, 3), (.large, 1)
        ]
        let notesByStool: [StoolType: [String]] = [
            .extraFirm: [
                "Very hard and dry today, she seemed to strain a bit getting it out.",
                "Small hard pellets, harder than her usual. Adding more water to her bowl.",
                "Straining more than normal, stool was quite dry and compact."
            ],
            .firm: [
                "Firm and well-formed, no straining. Good easy walk this morning.",
                "Solid stool, picked up easily. Normal color and consistency.",
                "Firm but not hard, everything looked routine.",
                "A little firmer than usual but no signs of discomfort."
            ],
            .normal: [
                "Solid and well-formed, no straining. Back to her normal routine.",
                "Normal morning routine. Quick and easy, no issues.",
                "Good color and consistency, nothing unusual to note.",
                "Textbook normal stool today, she seemed happy on the walk.",
                "Everything looked great, easy pickup, good shape."
            ],
            .soft: [
                "Softer than usual this evening. Might be from the new treats.",
                "A bit loose today, no blood or mucus though. Will monitor.",
                "Soft serve consistency, still held together okay.",
                "Slightly soft, maybe from all the water she drank after the park."
            ],
            .mushy: [
                "Mushy and harder to pick up today. She got into some grass on the walk.",
                "Loose and mushy, no blood or mucus present. Watching her diet today.",
                "Not fully formed, a little concerning but she's acting normal otherwise."
            ],
            .watery: [
                "Watery stool, definitely upset stomach. Keeping her hydrated and monitoring closely.",
                "Very loose and watery this time. Will call the vet if it continues past tomorrow.",
                "Runny and hard to clean up. She seems a little low energy today too."
            ]
        ]
        let timeWindows: [(ClosedRange<Int>, ClosedRange<Int>)] = [
            (6...9, 0...59), (11...15, 0...59), (17...21, 0...59)
        ]

        func weightedPick<Value>(_ weights: [(Value, Int)]) -> Value {
            let total = weights.reduce(0) { $0 + $1.1 }
            var roll = Int.random(in: 0..<total, using: &generator)
            for (value, weight) in weights {
                if roll < weight {
                    return value
                }
                roll -= weight
            }
            return weights[0].0
        }

        func note(for stoolType: StoolType, mucus: MucusLevel, blood: BloodAmount) -> String {
            var parts = [notesByStool[stoolType]!.randomElement(using: &generator)!]
            if mucus != .none {
                parts.append(
                    "Noticed \(mucus.name.lowercased()) mucus coating, keeping an eye on it.")
            }
            if blood != .none {
                parts.append("Saw a \(blood.name.lowercased()) amount of blood — will monitor it.")
            }
            return parts.joined(separator: " ")
        }

        var diaries: [Diary] = []
        var day = oldestDay
        while day <= today {
            let skippedDay =
                Int.random(in: 0..<100, using: &generator) < 40
                ? Int.random(in: 0..<7, using: &generator) : -1

            for dayIndex in 0..<7 {
                guard day <= today else { break }
                defer { day = calendar.date(byAdding: .day, value: 1, to: day)! }
                guard dayIndex != skippedDay else { continue }

                let entryCount = Int.random(in: 2...3, using: &generator)
                var windowIndices = Array(timeWindows.indices)
                windowIndices.shuffle(using: &generator)

                for entryIndex in 0..<entryCount {
                    let window = timeWindows[windowIndices[entryIndex % windowIndices.count]]
                    let hour = Int.random(in: window.0, using: &generator)
                    let minute = Int.random(in: window.1, using: &generator)
                    let stoolType = weightedPick(stoolWeights)
                    let mucusLevel = weightedPick(mucusWeights)
                    let bloodAmount = weightedPick(bloodWeights)
                    let photoCount = Int.random(in: 0...2, using: &generator)

                    diaries.append(
                        Diary(
                            id: UUID(),
                            petId: petId,
                            date: calendar.date(
                                bySettingHour: hour, minute: minute, second: 0, of: day)!,
                            stoolType: stoolType,
                            mucusLevel: mucusLevel,
                            bloodAmount: bloodAmount,
                            note: note(for: stoolType, mucus: mucusLevel, blood: bloodAmount),
                            photos: (0..<photoCount).map { _ in Photo.mock() },
                            tags: []
                        )
                    )
                }
            }
        }

        return diaries.sorted { $0.date > $1.date }
    }
}
#endif
