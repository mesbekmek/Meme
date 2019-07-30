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
    var templates = [Template]()
    var templateExample = TemplateExample(name: "", exampleURL: URL(string: "https://www.apple.com")!)
    var meme = Meme(name: "", imageURL: URL(string: "https://www.apple.com")!)

    init(templateParser: TemplateParser, memeParser: MemeParser, templateExampleParser: TemplateExampleParser) {
        self.templateParser = templateParser
        self.memeParser = memeParser
        self.templateExampleParser = templateExampleParser
    }

    fileprivate func getTemplates(_ data: Data?) -> [Template]? {
        if let data = data {
            if let templates = self.templateParser.parse(data: data) {
                return templates
            }
        }
        return nil
    }

    fileprivate func getTemplateExample(_ data: Data?) -> TemplateExample? {
        if let data = data {
            if let templateExample = self.templateExampleParser.parse(data: data) {
                return templateExample
            }
        }
        return nil
    }

    fileprivate func getMemes(_ data: Data?, memeName: String) -> Meme? {
        if let data = data {
            if let meme = self.memeParser.parse(imageData: data, memeName: memeName) {
                return meme
            }
        }
        return nil
    }

    func requestTemplates()  {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url =  URL(string: "https://memegen.link/api/templates")!
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            guard let templates = self.getTemplates(data) else { return }
            self.templates = templates
        }
        task.resume()
    }

    func requestTemplateExample(_ template: Template) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url =  template.templateURL
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            guard let templateExamples = self.getTemplateExample(data) else { return }
            self.templateExample = templateExamples
        }
        task.resume()
    }

    func requestMeme(_ templateExample: TemplateExample) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url =  templateExample.exampleURL
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            guard let meme = self.getMemes(data, memeName: templateExample.name) else { return }
            self.meme = meme
        }
        task.resume()
    }

}
