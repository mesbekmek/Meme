//
//  TemplateExampleParser.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

struct TemplateExampleParser {
    func parse(data: Data) -> TemplateExample? {
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any],
            let name = jsonResponse["name"] as? String,
            let example = jsonResponse["example"] as? String,
            let exampleURL = URL(string: example) else {
                print("Error parsing template example");
                return nil
        }
        return TemplateExample(name: name, exampleURL: exampleURL)
    }
}
