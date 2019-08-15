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
                let alertController = UIAlertController.createAlertController(for: error)
                DispatchQueue.main.async {
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
