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
}

extension Template {
    init?(dictionary: [String:Any]) {
        guard let key = dictionary.keys.first,
            let value = dictionary[key] as? String,
            let templateURL = URL(string: value) else {
                print("Error parsing data into Template model")
                return nil
        }
        self.name = key
        self.templateURL = templateURL
    }
}
