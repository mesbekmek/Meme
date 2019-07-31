//
//  NetworkClient.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

class NetworkClient {

    let templateParser: TemplateParser
    let memeParser: MemeParser
    let templateExampleParser: TemplateExampleParser

    init(templateParser: TemplateParser, memeParser: MemeParser, templateExampleParser: TemplateExampleParser) {
        self.templateParser = templateParser
        self.memeParser = memeParser
        self.templateExampleParser = templateExampleParser
    }

    fileprivate func getTemplates(_ data: Data?) -> [Template]? {
        guard let data = data,
            let templates = self.templateParser.parse(data: data) else {return nil}
        return templates
    }

    fileprivate func getTemplateExample(_ data: Data?) -> TemplateExample? {
        guard let data = data,
            let templateExample = self.templateExampleParser.parse(data: data) else {return nil}
        return templateExample
    }

    fileprivate func getMemes(_ data: Data?, memeName: String) -> Meme? {
        guard let data = data,
            let meme = self.memeParser.parse(imageData: data, memeName: memeName) else {return nil}
        return meme
    }

    func requestTemplates(completion: @escaping ([Template]) -> Void)  {
        let session = URLSession.shared
        let url =  URL(string: "https://memegen.link/api/templates")!
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            guard let templates = self.getTemplates(data) else { return }
            completion(templates)
        }
        task.resume()
    }

    func requestTemplateExample(_ template: Template, completion: @escaping (TemplateExample) -> Void) {
        let session = URLSession.shared
        let url =  template.templateURL
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            guard let templateExample = self.getTemplateExample(data) else { return }
            completion(templateExample)
        }
        task.resume()
    }

    func requestMeme(_ templateExample: TemplateExample, completion: @escaping (Meme) -> Void) {
        let session = URLSession.shared
        let url =  templateExample.exampleURL
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            guard let meme = self.getMemes(data, memeName: templateExample.name) else { return }
            completion(meme)
        }
        task.resume()
    }

}
