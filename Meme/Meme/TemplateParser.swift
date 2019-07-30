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
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                jsonResponse.forEach { (element) in
                    let (key, value) = element
                    if let templateURL = value as? URL {
                        let template = Template(name: key, templateURL: templateURL)
                        templates.append(template)
                    }
                }
            }
        } catch let error as NSError {
            print("Error decoding values: \(error.localizedDescription)")
            return nil
        }
        return templates
    }
}
