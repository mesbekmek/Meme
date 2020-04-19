//
//  MemeTemplatesCollectionViewCell.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 8/23/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class MemeTemplatesCollectionViewCell: UICollectionViewCell {

    static let sizingCell = MemeTemplatesCollectionViewCell(frame: .zero)

    lazy var memeImageView: AsyncImageView = {
        var imageView = AsyncImageView()
        imageView.onAsyncImageSet = { [weak self] in self?.updateLayout() }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var maxWidthConstraint: NSLayoutConstraint!

    var maxWidth: CGFloat? = nil {
        didSet {
            guard let maxWidth = maxWidth, oldValue != maxWidth else {
                return
            }
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
            memeImageView.maxWidth = maxWidth
            self.contentView.setNeedsLayout()
            self.contentView.layoutIfNeeded()
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
            memeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            memeImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            memeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }

    private func updateLayout() {
        onAsyncLoad?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        memeImageView.prepareForReuse()
    }
}

class ScaledHeightImageView: UIImageView {

    var maxWidth: CGFloat = 0

    override var intrinsicContentSize: CGSize {
        print("calculating intrinsic cont size")

        if let myImage = self.image {
            print("I have an image")
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = maxWidth

            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio

            return CGSize(width: myViewWidth, height: scaledHeight)
        }

        return CGSize(width: CGFloat.leastNormalMagnitude, height: CGFloat.leastNormalMagnitude)
    }

}

class AsyncImageView: ScaledHeightImageView {

    private(set) var didLoad = false

    var imageURL: URL? {
        didSet {
            if let url = imageURL {
                loadWithURL(url)
            }
        }
    }

    var onAsyncImageSet: (() -> Void)?

    func prepareForReuse() {
        image = nil
        imageURL = nil
        didLoad = false
    }

    private func loadWithURL(_ url: URL) {
        if let image = AsyncFetcher.shared.fetchedData(for: url) {
            self.didLoad = true
            self.image = image
        } else {
            self.image = UIImage(named: "placeholder")
            AsyncFetcher.shared.fetchAsync(url) { [weak self] image in
                DispatchQueue.main.async {
                    if self?.imageURL == url {
                        self?.didLoad = true
                        self?.image = image
                        self?.onAsyncImageSet?()
                    }
                }
            }
        }
    }
}
