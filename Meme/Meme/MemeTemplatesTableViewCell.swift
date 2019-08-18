//
//  MemeTemplatesTableViewCell.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/17/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class MemeTemplatesTableViewCell: UITableViewCell {

    var memeImageView: UIImageView = {
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

extension UIImageView {

    func load(url: URL, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
}
