//
//  NetworkClient.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

class NetworkClient {

    func requestTemplates(completion: @escaping (Result<[Template], MemeClientError>) -> Void)  {
        let session = URLSession.shared
        let urlBuilder = MemeEndpointBuilder()
        let url = urlBuilder.endpointURL(.template)
        let request = URLRequest(url:url)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            guard let data = data else {
                if let error = error as? MemeClientError {
                    completion(.failure(error))
                } else {
                    let responseError = (response as? HTTPURLResponse)?.apiError ?? .unknownError
                    completion(.failure(responseError))
                }
                return
            }

            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:String] else {
                completion(.failure(MemeClientError.jsonDeserializationError))
                return
            }
            completion(.success(jsonResponse.compactMap({ return Template(name: $0.0, templateURLString: $0.1)})))
        }
        task.resume()
    }
}

extension HTTPURLResponse {
    var apiError: MemeClientError? {
        switch statusCode {
        case 100...199:
            return .networkError
        case 200...299:
            return nil
        case 300...399:
            return nil
        case 400...499:
            return .clientError
        case 500...599:
            return .serverError
        default:
            return .unknownError
        }
    }
}

enum MemeClientError: Error {
    case networkError
    case clientError
    case serverError
    case jsonDeserializationError
    case unknownError
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
        }
        return URL(string: memegenDomain + path)!

    }

    func imageURL(with id: String) -> URL? {
        return URL(string: memegenDomain + "\(id)/_.jpg")
    }
}
