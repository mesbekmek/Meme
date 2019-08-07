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
    var memes = [Meme]()
    init(viewModel: TemplatesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.requestTemplates { [weak self] templates in
            let _ = templates.compactMap({return self?.getMeme($0)})
            return nil
        }
    }

    func getMeme(_ template: Template) {
        if let meme = self.viewModel.getMeme(template: template) {
            self.memes.append(meme)
        }
    }
}
