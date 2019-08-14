//
//  NetworkClient.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

protocol TemplateClient {
    func getTemplates(_ data: Data) -> Result<[Template], RetrievalError>
}

class NetworkClient: TemplateClient {

    func requestTemplates(completion: @escaping (Result<[Template], RetrievalError>) -> Void)  {
        let session = URLSession.shared
        let urlBuilder = MemeEndpointBuilder()
        let url = urlBuilder.endpointURL(.template)
        let request = URLRequest(url:url)
        let task: URLSessionDataTask = session.dataTask(with: request) { [weak self] (data, response, error) -> Void in
            guard let data = data,
                let result = self?.getTemplates(data) else {
                    print("Error getting templates template data")
                    return
            }
            completion(result)
        }
        task.resume()
    }

    func getTemplates(_ data: Data) -> Result<[Template], RetrievalError> {
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String] else {
            print("Error deserializing template data")
            return .failure(.deserializationFailure)
        }
        return .success(jsonResponse.compactMap({ return Template.init(name: $0.0, templateURLString: $0.1)}))
    }
}

enum RetrievalError: Error {
    case deserializationFailure
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
