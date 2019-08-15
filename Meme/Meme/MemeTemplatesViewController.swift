//
//  MemeTemplatesViewController.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/19/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class MemeTemplatesViewController: UIViewController {

    let viewModel: TemplatesViewModel
    var templates = [Template]()
    init(viewModel: TemplatesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.requestTemplates { [weak self] result in
            switch result {
            case .success(let templates):
                self?.templates = templates
            case .failure(let error):
                switch error {
                case .jsonDeserializationError:
                    self?.presentAlert(with: "Error parsing JSON", actionTitle: "Okay", message: "Please try again later")
                case .networkError:
                    self?.presentAlert(with: "Network Error", actionTitle: "Okay", message: "Please try again later")
                case .serverError:
                    self?.presentAlert(with: "Server Error", actionTitle: "Okay", message: "Please try again later")
                case .clientError:
                    self?.presentAlert(with: "Client Error", actionTitle: "Okay", message: "Please try again later")
                case .unknownError:
                    self?.presentAlert(with: "Unkown Error", actionTitle: "Okay", message: "Uknown error occured, please try again later")
                }
            }
        }
    }

    fileprivate func presentAlert(with title:String, actionTitle:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
