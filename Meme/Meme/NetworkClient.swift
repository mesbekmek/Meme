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

    func requestTemplates(completion: @escaping ([Template]) -> Void)  {
        let session = URLSession.shared
        let urlBuilder = MemeEndpointBuilder()
        let url = urlBuilder.endpointURL(.template)
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            guard let templates = self.getTemplates(data) else { return }
            completion(templates)
        }
        task.resume()
    }

}

enum MemeAPIEndpoint {
    case template
}

struct MemeEndpointBuilder {
    private let baseURLString = "https://memegen.link/api/"
    private let memegenDomain = "https://memegen.link/"

    func endpointURL(_ type: MemeAPIEndpoint) -> URL {
        let path: String
        switch type {
        case .template: path = "templates"
            return URL(string: baseURLString + path)!
        }
    }

    func imageURL(with id: String) -> URL? {
        return URL(string: memegenDomain + "\(id)/_.jpg")
    }
}
