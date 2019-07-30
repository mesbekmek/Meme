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
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: imageData, options: []) as? [String:Any] {
                    if let imageURLDict = jsonResponse["direct"] as? [String:String] {
                        if let visibleImageString = imageURLDict["visible"] {
                            if let imageURL  = URL(string: visibleImageString) {
                                return Meme(name: memeName, imageURL: imageURL)
                            }
                        }
                    }
                }
            } catch let error as NSError {
                print("Error decoding values: \(error.localizedDescription)")
               return nil
            }
        return nil
    }
}
