//
//  ImageCache.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/23/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

protocol ImageCaching {
    func getImage(for url: URL) -> UIImage?
    func setImage(image: UIImage, for url: URL)
}

class ImageCache: ImageCaching {
    static let shared = ImageCache()
    private var imageDictionary: [URL:UIImage] = [:]
    private let lock = NSRecursiveLock()

    func getImage(for url: URL) -> UIImage? {
        return imageDictionary[url]
    }

    func setImage(image: UIImage, for url: URL) {
        lock.lock()
        defer {
            lock.unlock()
        }
        imageDictionary[url] = image
    }
}
