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

    var templates = [Template]()
    init(viewModel: TemplatesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.addSubview(self.tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(MemeTemplatesTableViewCell.self, forCellReuseIdentifier: cellID)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 250
        self.viewModel.requestTemplates { [weak self] result in
            switch result {
            case .success(let templates):
                self?.templates = templates
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                let alertController = UIAlertController.createAlertController(for: error)
                DispatchQueue.main.async {
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
            cell.memeImageView.load(url: imageURL) { image in
                if let cellToUpdate = self.tableView.cellForRow(at: indexPath) as? MemeTemplatesTableViewCell {
                    cellToUpdate.memeImageView.image = image
                    cellToUpdate.setNeedsLayout()
                }
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
