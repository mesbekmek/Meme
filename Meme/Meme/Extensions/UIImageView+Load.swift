//
//  UIImageView+Load.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/23/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

extension UIImageView {
   func load(url: URL, completion: @escaping (UIImage) -> Void) {
        if let image = ImageCache.shared.getImage(for: url) {
            completion(image)
        } else {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image: image, for: url)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    func load(url: URL,
              immediate: (UIImage) -> Void,
              placeholder: UIImage,
              completion: @escaping (UIImage) -> Void) {
        if let image = ImageCache.shared.getImage(for: url) {
            immediate(image)
        } else {
            immediate(placeholder)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image: image, for: url)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
}
