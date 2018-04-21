//
//  ApiManager.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager {
    private init() { }
    static var shared = ApiManager()

    let urlAPI = "https://pixabay.com/api/?key=8692212-e4cde87b24564d139a6686c6e"
    
    func getImages(for string: String, finished: @escaping (Bool, [Item]) -> Void) {
        Alamofire.request(
            URL(string: urlAPI)!,
            method: .get,
            parameters: ["q": string,
                         "image_type": "photo"])
            .validate()
            .responseJSON { (response) -> Void in
                guard response.result.isSuccess else {
                    print("Error while fetching remote rooms: \(String(describing: response.result.error))")
                    finished(false, [])
                    return
                }
                
                // check structure
                guard let value = response.result.value as? [String: Any],
                    let items = value["hits"] as? [[String: Any]] else {
                        print("Malformed data received from get images service")
                        finished(false, [])
                        return
                }
                
                print(response.result.value as Any)
                
                // save infos
                var localItems: [Item] = []
                for i in items {
                    let item = Item(id: i["id"] as! Int,
                                    userName: i["user"] as! String,
                                    userImageUrl: i["userImageURL"] as! String,
                                    imageUrl: i["largeImageURL"] as! String,
                                    favorite: false,
                                    favoriteNumber: i["favorites"] as! Int,
                                    tags: i["tags"] as! String)
                    localItems.append(item)
                }
                
                finished(true,localItems)
        }
    }
    
}
