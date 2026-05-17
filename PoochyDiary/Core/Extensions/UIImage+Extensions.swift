//
//  UIImage+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/16/26.
//

import UIKit

extension UIImageView {
    func setImageURL(_ url: URL) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] data, response, error in
            guard let self,
                  let data,
                  let response = response as? HTTPURLResponse,
                  error == nil else { return }

            guard 200..<300 ~= response.statusCode,
                  let image = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
