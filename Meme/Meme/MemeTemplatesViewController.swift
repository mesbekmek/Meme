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
                print("Error requesting memes \(error.localizedDescription)")
            }
        }
    }
}
