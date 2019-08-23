//
//  MemeTemplatesCollectionViewCell.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/23/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class MemeTemplatesCollectionViewCell: UICollectionViewCell {

    lazy var memeImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var maxHeightConstraint: NSLayoutConstraint! {
        didSet {
            maxHeightConstraint.isActive = false
        }
    }

    var maxHeight: CGFloat? = nil {
        didSet {
            guard let maxHeight = maxHeight else {
                return
            }
            maxHeightConstraint.isActive = true
            maxHeightConstraint.constant = maxHeight
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(memeImageView)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let constraint = memeImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 250)
        self.maxHeightConstraint = constraint
        NSLayoutConstraint.activate([
            memeImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
            memeImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
            memeImageView.topAnchor.constraint(equalTo: self.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            //self.maxHeightConstraint
            ])
    }
}
