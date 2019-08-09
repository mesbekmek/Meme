//
//  NetworkClient.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

protocol MemeClient {
    func getMeme(from template: Template) -> Meme?
}

class NetworkClient: MemeClient {

    fileprivate func getTemplates(_ data: Data?) -> [Template]? {
        guard let data = data,
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String] else {
                print("Error deserializing template data");
                return nil
        }
        return jsonResponse.compactMap({ return Template.init(name: $0.0, templateURLString: $0.1)})
    }

    func requestTemplates(completion: @escaping ([Template]) -> Void)  {
        let session = URLSession.shared
        let urlBuilder = MemeEndpointBuilder()
        let url = urlBuilder.endpointURL(.template)
        let request = URLRequest(url:url)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            guard let templates = self.getTemplates(data) else { return }
            completion(templates)
        }
        task.resume()
    }

    func requestMemes(completion: @escaping ([Meme]?) -> Void) {
        requestTemplates { [weak self] templates in
            completion(templates.compactMap({ return self?.getMeme(from: $0)}))
        }
    }

    func getMeme(from template: Template) -> Meme? {
        let urlBuilder = MemeEndpointBuilder()
        guard let imageAlias = template.imageAlias,
            let  imageURL = urlBuilder.imageURL(with: imageAlias) else {
                print("Error constructing Meme model")
                return nil
        }

        return Meme(name: template.name, imageURL: imageURL)
    }
}

enum MemeAPIEndpoint {
    case template
}

struct MemeEndpointBuilder {
    private let memegenDomain = "https://memegen.link/"

    func endpointURL(_ type: MemeAPIEndpoint) -> URL {
        let path: String
        switch type {
        case .template: path = "api" + "/" + "templates"
            return URL(string: memegenDomain + path)!
        }
    }

    func imageURL(with id: String) -> URL? {
        return URL(string: memegenDomain + "\(id)/_.jpg")
    }
}
