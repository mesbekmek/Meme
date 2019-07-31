//
//  TemplateParser.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

struct TemplateParser {

    func parse(data: Data) -> [Template]? {
        var templates = [Template]()
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
            print("Error parsing templates");
            return nil
        }

        jsonResponse.forEach { (element) in
            let (key, value) = element
            if let templateURL = value as? String {
                let template = Template(name: key, templateURL: URL(string: templateURL)!)
                templates.append(template)
            }
        }
        return templates
    }
}
