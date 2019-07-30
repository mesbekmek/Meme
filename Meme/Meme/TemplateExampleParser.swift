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
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                if let name = jsonResponse["name"] as? String, let exampleURL = jsonResponse["example"] as? URL {
                    return TemplateExample(name: name, exampleURL: exampleURL)
                }
            }
        } catch let error as NSError {
            print("Error decoding values: \(error.localizedDescription)")
            return nil
        }
        return nil
    }
}
