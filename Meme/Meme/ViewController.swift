//
//  ViewController.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/19/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let viewModel: ViewModel
    var memes = [Meme]()
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.requestTemplates { [weak self] templates in
            templates.forEach({ template in
                self?.getTemplateExample(template)
            })
        }
    }

    func getTemplateExample(_ template: Template) {
        self.viewModel.requestTemplateExample(template: template) { [weak self] templateExample in
            self?.getMeme(templateExample)
        }
    }

    func getMeme(_ templateExample: TemplateExample) {
        self.viewModel.requestMeme(templateExample: templateExample) { [weak self] meme in
            self?.memes.append(meme)
        }
    }
}
