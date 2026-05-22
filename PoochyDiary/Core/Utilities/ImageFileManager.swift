//
//  ImageFileManager.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/21/26.
//

import UIKit

protocol ImageFileManaging {
    func saveImage(image: UIImage, fileName: String) throws
    func deleteImage(fileName: String) throws
}

enum ImageFileManagerError: Error {
    case failedToConvertImageData
    case folderURLNotFound
    case fileDeleteError(Error)
}

final class ImageFileManager: ImageFileManaging {
    let fileManager: FileManager
    let folderURL: URL?

    init?(fileManager: FileManager = FileManager()) {
        self.fileManager = fileManager

        folderURL = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appending(
                path: "PoopLogPhotos",
                directoryHint: .isDirectory
            )

        guard let folderURL,
           !fileManager.fileExists(atPath: folderURL.path()) else {
            return
        }

        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
        } catch {
            return nil
        }
    }
    
    func saveImage(image: UIImage, fileName: String) throws {
        guard let folderURL else {
            throw ImageFileManagerError.folderURLNotFound
        }

        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw ImageFileManagerError.failedToConvertImageData
        }

        let fileURL = folderURL.appendingPathComponent(fileName)
        try imageData.write(to: fileURL)
    }
    
    func deleteImage(fileName: String) throws {
        guard let folderURL else {
            throw ImageFileManagerError.folderURLNotFound
        }
    
        let fileURL = folderURL.appendingPathComponent(fileName)

        do {
            try fileManager.removeItem(at: fileURL)
        } catch{
            throw ImageFileManagerError.fileDeleteError(error)
        }
    }
}
