//
//  DiaryViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import Foundation

class DiaryViewModel {
  struct DisplayedDate {
    let date: Date
    let hasDiary: Bool
    let isSelected: Bool
  }

  @Published var visibleWeekDate = Date()
  @Published var displayedDates: [DisplayedDate] = []
  @Published var diaries: [Diary] = []

  init() {
    displayedDates = Self.makeMockDisplayedDates()
    diaries = Self.generateMockData()
    updateDisplayedDates()
  }

  func moveVisibleWeek(by offset: Int) {
    guard
      let date = Calendar.current.date(
        byAdding: .weekOfYear,
        value: offset,
        to: visibleWeekDate
      )
    else {
      return
    }

    visibleWeekDate = date
    updateDisplayedDates()
  }

  func selectDate(_ date: Date) {
    visibleWeekDate = date
    updateDisplayedDates()
  }

  private func updateDisplayedDates() {
    let calendar = Calendar.current

    guard
      let visibleWeekStart = calendar.dateInterval(
        of: .weekOfYear,
        for: visibleWeekDate
      )?.start
    else {
      return
    }

    displayedDates = (-7...13).compactMap { offset in
      guard
        let date = calendar.date(
          byAdding: .day,
          value: offset,
          to: visibleWeekStart
        )
      else {
        return nil
      }

      return DisplayedDate(
        date: date,
        hasDiary: diaries.contains {
          calendar.isDate($0.date, inSameDayAs: date)
        },
        isSelected: calendar.isDate(date, inSameDayAs: visibleWeekDate)
      )
    }
  }
}

extension DiaryViewModel {
  static let mockData: [Diary] = generateMockData()

  static func makeMockDisplayedDates() -> [DisplayedDate] {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())

    return (-6...0).compactMap { offset in
      guard let date = calendar.date(byAdding: .day, value: offset, to: today) else {
        return nil
      }

      return DisplayedDate(
        date: date,
        hasDiary: mockData.contains { calendar.isDate($0.date, inSameDayAs: date) },
        isSelected: calendar.isDate(date, inSameDayAs: today)
      )
    }
  }

  static func makeMockPhoto() -> Photo {
    Photo(
      id: UUID(), fileName: "",
      imageURL: URL(
        string:
          "https://smb.ibsrv.net/imageresizer/image/article_manager/1200x1200/8737/1279397/heroimage0.254710001739122294.jpg"
      ), createdAt: Date(), sortOrder: 0)
  }

  /// Deterministic RNG so mock data is stable across app launches.
  struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
      state = seed
    }

    mutating func next() -> UInt64 {
      state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
      return state
    }
  }

  /// Generates roughly 6 months of diary: 2-3 entries per logged day, with
  /// most weeks having a full 7 logged days and some weeks skipping 1 day.
  static func generateMockData() -> [Diary] {
    var rng = SeededGenerator(seed: 20_260_711)
    let calendar = Calendar.current
    let petId = UUID()
    let today = calendar.startOfDay(for: Date())
    let totalDays = 183  // ~6 months
    let oldestDay = calendar.date(byAdding: .day, value: -(totalDays - 1), to: today)!

    func time(_ base: Date, hour: Int, minute: Int) -> Date {
      calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base)!
    }

    let stoolWeights: [(StoolType, Int)] = [
      (.normal, 40),
      (.firm, 25),
      (.soft, 20),
      (.mushy, 8),
      (.extraFirm, 4),
      (.watery, 3),
    ]
    let mucusWeights: [(MucusLevel, Int)] = [
      (.none, 70),
      (.trace, 15),
      (.mild, 10),
      (.moderate, 4),
      (.heavy, 1),
    ]
    let bloodWeights: [(BloodAmount, Int)] = [
      (.none, 80),
      (.speck, 10),
      (.streak, 6),
      (.moderate, 3),
      (.large, 1),
    ]

    func weightedPick<T>(_ weights: [(T, Int)], using rng: inout SeededGenerator) -> T {
      let total = weights.reduce(0) { $0 + $1.1 }
      var roll = Int.random(in: 0..<total, using: &rng)
      for (value, weight) in weights {
        if roll < weight { return value }
        roll -= weight
      }
      return weights[0].0
    }

    let notesByStool: [StoolType: [String]] = [
      .extraFirm: [
        "Very hard and dry today, she seemed to strain a bit getting it out.",
        "Small hard pellets, harder than her usual. Adding more water to her bowl.",
        "Straining more than normal, stool was quite dry and compact.",
      ],
      .firm: [
        "Firm and well-formed, no straining. Good easy walk this morning.",
        "Solid stool, picked up easily. Normal color and consistency.",
        "Firm but not hard, everything looked routine.",
        "A little firmer than usual but no signs of discomfort.",
      ],
      .normal: [
        "Solid and well-formed, no straining. Back to her normal routine.",
        "Normal morning routine. Quick and easy, no issues.",
        "Good color and consistency, nothing unusual to note.",
        "Textbook normal stool today, she seemed happy on the walk.",
        "Everything looked great, easy pickup, good shape.",
      ],
      .soft: [
        "Softer than usual this evening. Might be from the new treats.",
        "A bit loose today, no blood or mucus though. Will monitor.",
        "Soft serve consistency, still held together okay.",
        "Slightly soft, maybe from all the water she drank after the park.",
      ],
      .mushy: [
        "Mushy and harder to pick up today. She got into some grass on the walk.",
        "Loose and mushy, no blood or mucus present. Watching her diet today.",
        "Not fully formed, a little concerning but she's acting normal otherwise.",
      ],
      .watery: [
        "Watery stool, definitely upset stomach. Keeping her hydrated and monitoring closely.",
        "Very loose and watery this time. Will call the vet if it continues past tomorrow.",
        "Runny and hard to clean up. She seems a little low energy today too.",
      ],
    ]

    func note(
      stoolType: StoolType, mucusLevel: MucusLevel, bloodAmount: BloodAmount,
      using rng: inout SeededGenerator
    ) -> String {
      var parts: [String] = []
      if let base = notesByStool[stoolType]?.randomElement(using: &rng) {
        parts.append(base)
      }
      if mucusLevel != .none {
        parts.append("Noticed \(mucusLevel.name.lowercased()) mucus coating, keeping an eye on it.")
      }
      if bloodAmount != .none {
        parts.append(
          "Saw a \(bloodAmount.name.lowercased()) amount of blood — will monitor over the next day or two."
        )
      }
      return parts.joined(separator: " ")
    }

    // Time-of-day windows entries are spread across (morning, midday, evening).
    let timeWindows: [(hourRange: ClosedRange<Int>, minuteRange: ClosedRange<Int>)] = [
      (6...9, 0...59),
      (11...15, 0...59),
      (17...21, 0...59),
    ]

    var diaries: [Diary] = []

    var dayCursor = oldestDay
    while dayCursor <= today {
      // Determine this week's skip day (0, or 1 out of the next 7 days), then
      // walk 7 days at a time so "not all weeks" skip a day.
      let weekSkips: Bool = Int.random(in: 0..<100, using: &rng) < 40  // ~40% of weeks skip a day
      let skipDayIndex = weekSkips ? Int.random(in: 0..<7, using: &rng) : -1

      for offset in 0..<7 {
        guard dayCursor <= today else { break }
        defer { dayCursor = calendar.date(byAdding: .day, value: 1, to: dayCursor)! }

        if offset == skipDayIndex {
          continue
        }

        let entryCount = Int.random(in: 2...3, using: &rng)
        var usedWindows = Array(timeWindows.indices)
        usedWindows.shuffle(using: &rng)

        for i in 0..<entryCount {
          let window = timeWindows[usedWindows[i % usedWindows.count]]
          let hour = Int.random(in: window.hourRange, using: &rng)
          let minute = Int.random(in: window.minuteRange, using: &rng)
          let stoolType = weightedPick(stoolWeights, using: &rng)
          let mucusLevel = weightedPick(mucusWeights, using: &rng)
          let bloodAmount = weightedPick(bloodWeights, using: &rng)
          let photoCount = Int.random(in: 0...2, using: &rng)

          diaries.append(
            Diary(
              id: UUID(),
              petId: petId,
              date: time(dayCursor, hour: hour, minute: minute),
              stoolType: stoolType,
              mucusLevel: mucusLevel,
              bloodAmount: bloodAmount,
              note: note(
                stoolType: stoolType, mucusLevel: mucusLevel, bloodAmount: bloodAmount, using: &rng),
              photos: (0..<photoCount).map { _ in makeMockPhoto() },
              tags: []
            )
          )
        }
      }
    }

    return diaries.sorted { $0.date > $1.date }
  }
}
