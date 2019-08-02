//
//  NetworkClient.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

class NetworkClient {

    fileprivate func getTemplates(_ data: Data?) -> [Template]? {
        guard let data = data,
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                print("Error deserializing template data");
                return nil
        }

        var templates = [Template]()
        jsonResponse.forEach { (key, value) in
            var dictionary = [String:Any]()
            dictionary[key] = value
            if let template = Template.init(dictionary: dictionary) {
                templates.append(template)
            }
        }
        return templates
    }

    fileprivate func getTemplateExample(_ data: Data?) -> TemplateExample? {
        guard let data = data,
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
            let templateExample = TemplateExample.init(dictionary: jsonResponse) else {
                print("Error deserializing template example data");
                return nil
        }

        return templateExample
    }

    fileprivate func getMeme(_ data: Data?, memeName: String) -> Meme? {
        guard let data = data,
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
            let meme = Meme.init(dictionary: jsonResponse, memeName: memeName) else {
                print("Error deserializing Meme data");
                return nil
        }
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
            guard let meme = self.getMeme(data, memeName: templateExample.name) else { return }
            completion(meme)
        }
        task.resume()
    }

}
