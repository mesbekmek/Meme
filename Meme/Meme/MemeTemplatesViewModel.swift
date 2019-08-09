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
    func requestMemes(completion: @escaping ([Meme]) -> Void)
}

struct MemeTemplatesViewModel: TemplatesViewModel {
    private let networkClient: NetworkClient

     init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func requestTemplates(completion: @escaping ([Template]) -> Void?) {
        self.networkClient.requestTemplates { templates in
            completion(templates)
        }
    }

    func requestMemes(completion: @escaping ([Meme]) -> Void) {
        self.networkClient.requestMemes { memes in
            if let memes = memes {
                completion(memes)
            }
        }
    }
}
