//
//  Meme.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/29/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import Foundation

struct Meme {
    let name: String
    let imageURL: URL
}

extension Meme {
    init?(dictionary: [String:Any], memeName: String) {
        guard let imageURLDict = dictionary["direct"] as? [String:String],
            let visibleImageString = imageURLDict["visible"],
            let imageURL  = URL(string: visibleImageString) else {
                print("Error parsing dictionary to Meme data model")
                return nil
        }
        self.name = memeName
        self.imageURL = imageURL
    }
}
