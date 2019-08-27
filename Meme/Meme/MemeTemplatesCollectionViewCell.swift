//
//  MemeTemplatesCollectionViewCell.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/23/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class MemeTemplatesCollectionViewCell: UICollectionViewCell {

    lazy var memeImageView: AsyncImageView = {
        var imageView = AsyncImageView()
        imageView.onAsyncImageSet = { [weak self] in self?.updateLayout() }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }

    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
            self.layoutIfNeeded()
        }
    }

    var onAsyncLoad: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])

        self.maxWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0)
        self.maxWidthConstraint.priority = .required
        self.maxWidthConstraint.isActive = true

        contentView.addSubview(memeImageView)

        NSLayoutConstraint.activate([
            memeImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            memeImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            memeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            memeImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat.leastNonzeroMagnitude)
            ])
    }

    private func updateLayout() {
        onAsyncLoad?()
    }

    override func prepareForReuse() {
        memeImageView.image = nil
        super.prepareForReuse()
    }
}

class ScaledHeightImageView: UIImageView {

    override var intrinsicContentSize: CGSize {

        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
    }

}

class AsyncImageView: ScaledHeightImageView {
    var imageURL: URL? {
        didSet {
            if let url = imageURL {
                loadWithURL(url)
            }
        }
    }

    var onAsyncImageSet: (() -> Void)?

    private func loadWithURL(_ url: URL) {
        if let image = AsyncFetcher.shared.fetchedData(for: url) {
                self.image = image
        } else {
            self.image = UIImage(named: "placeholder")
            self.layoutIfNeeded()
            AsyncFetcher.shared.fetchAsync(url) { [weak self] image in
                DispatchQueue.main.async {
                    if self?.imageURL == url {
                        self?.image = image
                        self?.onAsyncImageSet?()
                    }
                }
            }
        }
    }
}
