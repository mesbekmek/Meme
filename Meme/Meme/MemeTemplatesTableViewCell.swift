//
//  MemeTemplatesTableViewCell.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/17/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class MemeTemplatesTableViewCell: UITableViewCell {

    lazy var memeImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(memeImageView)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            memeImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            memeImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            memeImageView.topAnchor.constraint(equalTo: self.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            memeImageView.heightAnchor.constraint(equalToConstant: 250)
            ])
    }
}

protocol ImageCaching {
    func getImage(for url: URL) -> UIImage?
    func setImage(image: UIImage, for url: URL)
}

class ImageCache: ImageCaching {
    static let shared = ImageCache()
    private var imageDictionary: [URL:UIImage] = [:]

    func getImage(for url: URL) -> UIImage? {
        return imageDictionary[url]
    }

    func setImage(image: UIImage, for url: URL) {
        imageDictionary[url] = image
    }
}

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
}
