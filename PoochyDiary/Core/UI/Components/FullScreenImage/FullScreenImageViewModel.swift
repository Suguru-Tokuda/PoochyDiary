//
//  FullScreenImageViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/5/26.
//

import Foundation

class FullScreenImageViewModel {
  let photos: [Photo]
  let startIndex: Int

  init(photos: [Photo], startIndex: Int) {
    self.photos = photos
    self.startIndex = startIndex
  }
}
