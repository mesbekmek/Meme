//
//  ViewController.swift
//  Meme
//
//  Created by Mesfin Bekele Mekonnen on 7/19/19.
//  Copyright © 2019 Mesfin Bekele Mekonnen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var networkClient: NetworkClient
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getMemeTemplates()
    }

    func getMemeTemplates() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let url =  URL(string: "https://memegen.link/api/templates")!
        let request = URLRequest(url:url)
        let task: URLSessionDataTask =  session.dataTask(with: request) { (data, response, error) -> Void in
            if let data =  data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        print(jsonResponse)
                    }
                } catch let error as NSError {
                    print("Error decoding values: \(error.localizedDescription)")
                }

            }
        }
        task.resume()
    }
}
