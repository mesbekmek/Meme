//
//  MemeTemplatesViewModel.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/30/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

protocol TemplatesViewModel {
    func requestTemplates(completion: @escaping (Result<[Template], MemeClientError>) -> Void)
}

struct MemeTemplatesViewModel: TemplatesViewModel {
    private let networkClient: NetworkClient

     init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func requestTemplates(completion: @escaping (Result<[Template], MemeClientError>) -> Void) {
        self.networkClient.requestTemplates { result in
            switch result {
            case .success(let templates):
                completion(.success(templates))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
