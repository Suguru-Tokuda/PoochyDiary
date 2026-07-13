//
//  Photo+Mock.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import Foundation

extension Photo {
    static func mock() -> Photo {
        Photo(
            id: UUID(),
            fileName: "",
            imageURL: URL(
                string:
                    "https://smb.ibsrv.net/imageresizer/image/article_manager/1200x1200/8737/1279397/heroimage0.254710001739122294.jpg"
            ),
            createdAt: Date(),
            sortOrder: 0
        )
    }
}
