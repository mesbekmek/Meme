//
//  MemeTemplatesViewModel.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/30/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

protocol TemplatesViewModel {
    func requestTemplates(completion: @escaping ([Template]) -> Void?)
    func getMeme(template: Template) -> Meme?
}

struct MemeTemplatesViewModel: TemplatesViewModel {
    private let networkClient: NetworkClient

     init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
}

extension MemeTemplatesViewModel {
    func requestTemplates(completion: @escaping ([Template]) -> Void?) {
        self.networkClient.requestTemplates { templates in
            completion(templates)
        }
    }

    func getMeme(template: Template) -> Meme? {
        let urlBuilder = MemeEndpointBuilder()
        guard let imageAlias = template.templateURL.pathComponents.last,
            let  imageURL = urlBuilder.imageURL(with: imageAlias) else {
                print("Error constructing Meme model")
                return nil
        }

        return Meme(name: template.name, imageURL: imageURL)
    }
}
