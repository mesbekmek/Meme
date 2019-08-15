//
//  Template.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

struct Template {
    let name: String
    let templateURL: URL
    let imageAlias: String?
    let imageURL: URL?

    init?(name: String, templateURLString: String) {
        let urlBuilder = MemeEndpointBuilder()
        guard let url = URL(string: templateURLString),
            let imageAlias = url.pathComponents.last,
            let imageURL = urlBuilder.imageURL(with: imageAlias) else {
                print("Error parsing Template data model")
                return nil
        }

        self.name = name
        self.templateURL = url
        self.imageAlias = imageAlias
        self.imageURL = imageURL
    }
}
