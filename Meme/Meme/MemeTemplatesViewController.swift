//
//  MemeTemplatesViewController.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/19/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class MemeTemplatesViewController: UIViewController {

    let cellID = "memeCell"
    let viewModel: TemplatesViewModel
    lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.frame = self.view.bounds
        return tableView
    }()

    lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: self.view.bounds,
                                              collectionViewLayout: collectionViewLayout)
        return collectionView
    }()

    let collectionViewLayout = MemeCollectionViewFlowLayout()

    var templates: [Template] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.reloadData()

            }
        }
    }
    
    var itemWidth: CGFloat {
        return collectionView.frame.width - 2 * spacing
    }

    private let spacing: CGFloat = 8

    init(viewModel: TemplatesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        collectionViewLayout.minimumInteritemSpacing = spacing
        self.view.addSubview(self.collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MemeTemplatesCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.collectionViewLayout.estimatedItemSize = CGSize(width: itemWidth, height: 200)

        self.viewModel.requestTemplates { [weak self] result in
            switch result {
            case .success(let templates):
                self?.templates = templates
            case .failure(let error):
                let alertController = UIAlertController.createAlertController(for: error)
                DispatchQueue.main.async {
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension MemeTemplatesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.layoutIfNeeded()
        return templates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.layoutIfNeeded()
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MemeTemplatesCollectionViewCell

        cell.maxWidth = itemWidth
        cell.onAsyncLoad = { [weak self] in
            self?.collectionViewLayout
                .invalidateLayout()
        }

        if let imageURL = self.templates[indexPath.row].imageURL {
            cell.memeImageView.imageURL = imageURL
        }
        return cell
    }
}

class MemeCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.scrollDirection = .vertical
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension UIAlertController {

    class func createAlertController(for error: MemeClientError) -> UIAlertController {
        switch error {
        case .jsonDeserializationError:
            return createAlert(with: "Error parsing JSON", actionTitle: "Okay", message: "Please try again later")
        case .networkError:
            return createAlert(with: "Network Error", actionTitle: "Okay", message: "Please try again later")
        case .serverError:
            return createAlert(with: "Server Error", actionTitle: "Okay", message: "Please try again later")
        case .clientError:
            return createAlert(with: "Client Error", actionTitle: "Okay", message: "Please try again later")
        case .unknownError:
            return createAlert(with: "Unkown Error", actionTitle: "Okay", message: "Uknown error occured, please try again later")
        }
    }

    class func createAlert(with title:String, actionTitle:String, message:String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        return alertController
    }
}
