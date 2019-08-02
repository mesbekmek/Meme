//
//  ViewModel.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/30/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

class ViewModel {

    let networkClient: NetworkClient

    required init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func requestTemplates(completion: @escaping ([Template]) -> Void?) {
        self.networkClient.requestTemplates { templates in
            completion(templates)
        }
    }

    func requestTemplateExample(template: Template, withCompletion completion: @escaping (TemplateExample) -> Void?) {
        self.networkClient.requestTemplateExample(template) { templateExample in
            completion(templateExample)
        }
    }

    func requestMeme(templateExample: TemplateExample, withCompletion completion: @escaping (Meme) -> Void?) {
        self.networkClient.requestMeme(templateExample) { meme in
            completion(meme)
        }
    }
}
