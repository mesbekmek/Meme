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
    var templates = [Template]()
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setupDelegates()
    }

    func setupDelegates() {

        self.viewModel.setDidDownloadTemplates(delegate: self) { (self, templates) in
            self.templates = templates

            self.templates.forEach({ [weak self] template in
                self?.getTemplateExample(template)
            })
        }

        self.viewModel.setDidDownloadTemplateExample(delegate: self) { (self, templateExample) in
            self.getMeme(templateExample)
        }

        self.viewModel.setDidDownloadMeme(delegate: self) { (self, meme) in
            self.memes.append(meme)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.requestTemplates()
    }

    func getTemplateExample(_ template: Template) {
        self.viewModel.requestTemplateExample(template: template)
    }

    func getMeme(_ templateExample: TemplateExample) {
        self.viewModel.requestMeme(templateExample: templateExample)
    }
}
