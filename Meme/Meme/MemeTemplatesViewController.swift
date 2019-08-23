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
        var collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: MemeCollectionViewFlowLayout())
        return collectionView
    }()

    var collectionViewLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    var collectionLayout: UICollectionViewFlowLayout? {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        self.collectionViewLayout = collectionLayout
        return collectionLayout
    }

    var templates: [Template] = [] {
        didSet {
            DispatchQueue.main.async { self.collectionView.reloadData() }
        }
    }
    init(viewModel: TemplatesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        //self.view.addSubview(self.tableView)
        self.view.addSubview(self.collectionView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.tableView.delegate = self
        //        self.tableView.dataSource = self
        //        self.tableView.register(MemeTemplatesTableViewCell.self, forCellReuseIdentifier: cellID)
        //        self.tableView.rowHeight = UITableView.automaticDimension
        //        self.tableView.estimatedRowHeight = 250

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MemeTemplatesCollectionViewCell.self, forCellWithReuseIdentifier: cellID)

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
}

extension MemeTemplatesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return templates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MemeTemplatesCollectionViewCell
        cell.memeImageView.image = nil
        if let imageURL = self.templates[indexPath.row].imageURL {
            cell.memeImageView.load(url: imageURL) { [weak cell, weak collectionView] image in
                guard let visibleItems = collectionView?.indexPathsForVisibleItems,
                let cell = cell,
                visibleItems.contains(indexPath) else {
                    print("I am returning nothingness")
                    return
                }
                cell.memeImageView.image = image
                cell.layoutIfNeeded()
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MemeTemplatesCollectionViewCell else { return }
        cell.memeImageView.image = nil
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

extension MemeTemplatesViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.templates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellID) as! MemeTemplatesTableViewCell
        cell.memeImageView.image = nil
        if let imageURL = self.templates[indexPath.row].imageURL {
            cell.memeImageView.load(url: imageURL) { [weak cell, weak tableView] image in
                guard let visiblePaths = tableView?.indexPathsForVisibleRows,
                    let cell = cell,
                    visiblePaths.contains(indexPath) else { return }
                cell.memeImageView.image = image
                cell.layoutIfNeeded()
            }
        }
        return cell
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
