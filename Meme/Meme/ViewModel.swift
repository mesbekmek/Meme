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
    private var didDownloadTemplates: (([Template]) -> Void)?
    private var didDownloadTemplateExample: ((TemplateExample) -> Void)?
    private var didDownloadMeme:((Meme) -> Void)?

    required init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func setDidDownloadTemplates<Object: AnyObject>(delegate:Object, completion: @escaping (Object, [Template]) -> Void) {
        self.didDownloadTemplates = { [weak delegate] templates in
            if let delegate = delegate {
                completion(delegate, templates)
            }
        }
    }

    func setDidDownloadTemplateExample<Object: AnyObject>(delegate:Object, completion: @escaping (Object, TemplateExample) -> Void) {
        self.didDownloadTemplateExample = { [weak delegate] templateExample in
            if let delegate = delegate {
                completion(delegate, templateExample)
            }
        }
    }

    func setDidDownloadMeme<Object: AnyObject>(delegate:Object, completion: @escaping (Object, Meme) -> Void) {
        self.didDownloadMeme = { [weak delegate] meme in
            if let delegate = delegate {
                completion(delegate, meme)
            }
        }
    }

    func requestTemplates() {
        self.networkClient.requestTemplates { templates in
            self.didDownloadTemplates?(templates)
        }
    }

    func requestTemplateExample(template: Template) {
        self.networkClient.requestTemplateExample(template) { templateExample in
            self.didDownloadTemplateExample?(templateExample)
        }
    }

    func requestMeme(templateExample: TemplateExample) {
        self.networkClient.requestMeme(templateExample) { meme in
            self.didDownloadMeme?(meme)
        }
    }
}
