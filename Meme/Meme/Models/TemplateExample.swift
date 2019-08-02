//
//  TemplateExample.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

struct TemplateExample {
    let name: String
    let exampleURL: URL
}

extension TemplateExample {
    init?(dictionary: [String:Any]) {
        guard let name = dictionary["name"] as? String,
            let example = dictionary["example"] as? String,
            let exampleURL = URL(string: example) else {
                print("Error parsing template example");
                return nil
        }
        self.name = name
        self.exampleURL = exampleURL
    }
}
