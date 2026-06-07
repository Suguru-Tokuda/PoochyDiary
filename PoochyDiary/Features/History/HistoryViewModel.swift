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
            PoopLog(id: UUID(), petId: petId, date: date(today, hour: 8, minute: 45),
                    stoolType: .normal, mucusLevel: .none, bloodAmount: .none, photos: [
                        makeMockPhoto(),
                        makeMockPhoto(),
                        makeMockPhoto()
                    ], tags: []),

            // Yesterday
            PoopLog(id: UUID(), petId: petId, date: date(yesterday, hour: 7, minute: 15),
                    stoolType: .firm, mucusLevel: .none, bloodAmount: .moderate, photos: [
                        makeMockPhoto()
                    ], tags: []),
            PoopLog(id: UUID(), petId: petId, date: date(yesterday, hour: 18, minute: 30),
                    stoolType: .soft, mucusLevel: .none, bloodAmount: .none, photos: [
                        makeMockPhoto()
                    ], tags: []),

            // 2 days ago
            PoopLog(id: UUID(), petId: petId, date: date(twoDaysAgo, hour: 8, minute: 20),
                    stoolType: .normal, mucusLevel: .none, bloodAmount: .none, photos: [makeMockPhoto()], tags: []),
            PoopLog(id: UUID(), petId: petId, date: date(twoDaysAgo, hour: 19, minute: 50),
                    stoolType: .mushy, mucusLevel: .none, bloodAmount: .moderate, photos: [makeMockPhoto()], tags: []),

            // 3 days ago
            PoopLog(id: UUID(), petId: petId, date: date(threeDaysAgo, hour: 9, minute: 10),
                    stoolType: .firm, mucusLevel: .mild, bloodAmount: .none, photos: [makeMockPhoto()], tags: [])
        ]
    }()

    static func makeMockPhoto() -> Photo {
        Photo(id: UUID(), fileName: "", imageURL: URL(string: "https://smb.ibsrv.net/imageresizer/image/article_manager/1200x1200/8737/1279397/heroimage0.254710001739122294.jpg"), createdAt: Date(), sortOrder: 0)
    }
}
