//
//  MemeParser.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

struct MemeParser {

    func parse(imageData: Data, memeName: String) -> Meme? {
        guard let jsonResponse = try? JSONSerialization.jsonObject(with: imageData, options: []) as? [String:Any],
            let imageURLDict = jsonResponse["direct"] as? [String:String],
            let visibleImageString = imageURLDict["visible"],
            let imageURL  = URL(string: visibleImageString) else {
                print("Error decoding values")
                return nil
        }
        return Meme(name: memeName, imageURL: imageURL)
    }
}
