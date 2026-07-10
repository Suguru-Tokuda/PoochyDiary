//
//  HistoryViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Foundation

class HistoryViewModel {
}

extension HistoryViewModel {
    static let mockData: [PoopLog] = {
        let petId = UUID()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: today)!
        let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: today)!

        func date(_ base: Date, hour: Int, minute: Int) -> Date {
            calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base)!
        }

        return [
            // Today
            PoopLog(
                id: UUID(),
                petId: petId,
                date: date(today, hour: 8, minute: 45),
                stoolType: .normal,
                mucusLevel: .none,
                bloodAmount: .none,
                note: "Morning walk after breakfast. Solid and well-formed, no straining. Seems back to normal after yesterday's soft stool.",
                photos: [makeMockPhoto(), makeMockPhoto(), makeMockPhoto()],
                tags: []
            ),

            // Yesterday
            PoopLog(
                id: UUID(),
                petId: petId,
                date: date(yesterday, hour: 7, minute: 15),
                stoolType: .firm,
                mucusLevel: .none,
                bloodAmount: .moderate,
                note: "Noticed a small amount of bright red blood at the end. Could be from straining — will monitor over the next day or two. Gave her plenty of water after the walk.",
                photos: [makeMockPhoto()],
                tags: []
            ),
            PoopLog(
                id: UUID(),
                petId: petId,
                date: date(yesterday, hour: 18, minute: 30),
                stoolType: .soft,
                mucusLevel: .none,
                bloodAmount: .none,
                note: "Softer than usual this evening. Ate a new treats brand yesterday — may be the cause. No blood or mucus, just looser consistency.",
                photos: [makeMockPhoto()],
                tags: []
            ),

            // 2 days ago
            PoopLog(
                id: UUID(),
                petId: petId,
                date: date(twoDaysAgo, hour: 8, minute: 20),
                stoolType: .normal,
                mucusLevel: .none,
                bloodAmount: .none,
                note: "Normal morning routine. Quick and easy, no issues. Good color and consistency.",
                photos: [makeMockPhoto()],
                tags: []
            ),
            PoopLog(
                id: UUID(),
                petId: petId,
                date: date(twoDaysAgo, hour: 19, minute: 50),
                stoolType: .mushy,
                mucusLevel: .none,
                bloodAmount: .moderate,
                note: "Mushy and harder to pick up. Small streak of blood noticed. She ate some grass on the afternoon walk — likely the culprit. Withholding new treats for now.",
                photos: [makeMockPhoto()],
                tags: []
            ),

            // 3 days ago
            PoopLog(
                id: UUID(),
                petId: petId,
                date: date(threeDaysAgo, hour: 9, minute: 10),
                stoolType: .firm,
                mucusLevel: .mild,
                bloodAmount: .none,
                note: "Firm stool with a slight coating of mucus. She was gassy overnight so this wasn't surprising. No blood. Will keep an eye on the mucus — if it persists more than a few days I'll call the vet.",
                photos: [makeMockPhoto()],
                tags: []
            )
        ]
    }()

    static func makeMockPhoto() -> Photo {
        Photo(id: UUID(), fileName: "", imageURL: URL(string: "https://smb.ibsrv.net/imageresizer/image/article_manager/1200x1200/8737/1279397/heroimage0.254710001739122294.jpg"), createdAt: Date(), sortOrder: 0)
    }
}
