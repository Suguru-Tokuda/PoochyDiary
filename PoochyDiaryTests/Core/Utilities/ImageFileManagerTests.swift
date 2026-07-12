//
//  ImageFileManagerTests.swift
//  PoochyDiaryTests
//

import Testing
import UIKit

@testable import PoochyDiary

struct ImageFileManagerTests {

  // MARK: - Helpers

  private func makeSUT() -> ImageFileManager? {
    ImageFileManager()
  }

  private func makeTestImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 10, height: 10))
    return renderer.image { ctx in
      UIColor.red.setFill()
      ctx.fill(CGRect(x: 0, y: 0, width: 10, height: 10))
    }
  }

  // MARK: - Init

  @Test func init_createsInstance() {
    #expect(makeSUT() != nil)
  }

  @Test func init_folderURLIsSet() {
    let sut = makeSUT()
    #expect(sut?.folderURL != nil)
  }

  // MARK: - Save

  @Test func saveImage_validImage_savesSuccessfully() throws {
    guard let sut = makeSUT() else {
      Issue.record("ImageFileManager init failed")
      return
    }

    let image = makeTestImage()
    let fileName = "test-image-\(UUID().uuidString)"

    let url = try sut.saveImage(image: image, fileName: fileName)
    #expect(FileManager.default.fileExists(atPath: url.path()))

    // cleanup
    try? sut.deleteImage(fileName: fileName)
  }

  @Test func saveImage_overwritesExistingFile() throws {
    guard let sut = makeSUT() else {
      Issue.record("ImageFileManager init failed")
      return
    }

    let image = makeTestImage()
    let fileName = "test-overwrite-\(UUID().uuidString)"

    let url1 = try sut.saveImage(image: image, fileName: fileName)
    let url2 = try sut.saveImage(image: image, fileName: fileName)

    #expect(url1 == url2)
    #expect(FileManager.default.fileExists(atPath: url2.path()))

    // cleanup
    try? sut.deleteImage(fileName: fileName)
  }

  @Test func saveImage_returnsFileURL() throws {
    guard let sut = makeSUT() else {
      Issue.record("ImageFileManager init failed")
      return
    }

    let image = makeTestImage()
    let fileName = "test-url-\(UUID().uuidString)"

    let url = try sut.saveImage(image: image, fileName: fileName)
    #expect(url.isFileURL)

    // cleanup
    try? sut.deleteImage(fileName: fileName)
  }

  // MARK: - Delete

  @Test func deleteImage_existingFile_deletesSuccessfully() throws {
    guard let sut = makeSUT() else {
      Issue.record("ImageFileManager init failed")
      return
    }

    let image = makeTestImage()
    let fileName = "test-delete-\(UUID().uuidString)"
    let url = try sut.saveImage(image: image, fileName: fileName)

    try sut.deleteImage(fileName: fileName)
    #expect(!FileManager.default.fileExists(atPath: url.path()))
  }

  @Test func deleteImage_nonExistentFile_doesNotThrow() throws {
    guard let sut = makeSUT() else {
      Issue.record("ImageFileManager init failed")
      return
    }

    // Should silently succeed since file doesn't exist
    try sut.deleteImage(fileName: "non-existent-file-\(UUID().uuidString)")
  }
}
