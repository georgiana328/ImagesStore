//
//  DatabaseManager+Operations.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 15/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import FBSDKCoreKit

extension DatabaseManager {
    
    func saveItems(_ items: [Item]) {
        try! realm.write {
            for i in items {
                add(i, update: false)
            }
        }
    }
    
    func updateObject(_ item: Item) {
        try! realm.write {
            add(item, update: true)
        }
    }
    
    func addFavoriteImage(withID id: Int) {
        guard let token = FBSDKAccessToken.current().appID else {
            return
        }
        
        var imagesIDs = getCurrentUserFavoriteImages()
        imagesIDs.append(ImageID(id: id))
        let user = User(token: token, favoriteImagesIDs: imagesIDs)

        try! realm.write {
            add(user, update: true)
        }
    }
    
    func removeFavoriteImage(withID id: Int) {
        guard let token = FBSDKAccessToken.current().appID else {
            return
        }
        
        var imagesIDs = getCurrentUserFavoriteImages()
        imagesIDs = imagesIDs.filter { $0.id != id }
        
        let user = User(token: token, favoriteImagesIDs: imagesIDs)

        try! realm.write {
            add(user, update: true)
        }
    }
    
    func checkFavoriteImage(withId id: Int) -> Bool {
        let favoriteImagesIds = getCurrentUserFavoriteImages().compactMap {$0.id}
        if favoriteImagesIds.contains(id) {
            return true
        } else {
            return false
        }
    }
    
    func createFavoriteImagesForUser() {
        guard let token = FBSDKAccessToken.current().appID else {
            return
        }
        
        let user = User(token: token, favoriteImagesIDs: [])

        try! realm.write {
            add(user, update: false)
        }
    }
    
    func getCurrentUserFavoriteImages() -> [ImageID] {
        let tkn = FBSDKAccessToken.current().appID
        
        let users = realm.objects(UserObject.self).filter{ $0.token == tkn! }
        
        if users.count != 1 {
            return []
        }
        return users[0].favoriteimagesIDs.compactMap { ImageID(managedObject: $0)}
    }
    
    func checkIfUserExists() -> Bool {
        let tkn = FBSDKAccessToken.current().appID
        let users = realm.objects(UserObject.self).filter { $0.token == tkn! }
        if users.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func getItems() -> [Item] {
        var localItems: [Item] = []
        
        let items = realm.objects(ItemObject.self)
        
        for i in items {
            let item = Item(id: i.id,
                            userName: i.userName,
                            userImageUrl: i.userImageUrl,
                            imageUrl: i.imageUrl,
                            favorite: i.favorite,
                            favoriteNumber: i.favoriteNumber,
                            tags: i.tags)
            localItems.append(item)
        }
        return localItems
    }
    
    func getFavoriteItems() -> [Item] {
        var localFavoriteItems: [Item] = []
        
        var items = Array(realm.objects(ItemObject.self))
        let favoriteImagesIDs = getCurrentUserFavoriteImages().compactMap { $0.id}

        items = items.filter { favoriteImagesIDs.contains($0.id) }

        for i in items {
            let item = Item(id: i.id,
                            userName: i.userName,
                            userImageUrl: i.userImageUrl,
                            imageUrl: i.imageUrl,
                            favorite: i.favorite,
                            favoriteNumber: i.favoriteNumber,
                            tags: i.tags)
            localFavoriteItems.append(item)
        }
        
        return localFavoriteItems
    }
    
    func searchItem(withName name: String) -> [Item] {
        var localItems: [Item] = []
        
        let items = realm.objects(ItemObject.self).filter { $0.tags.lowercased().range(of: name.lowercased()) != nil }
        
        for i in items {
            let item = Item(id: i.id,
                            userName: i.userName,
                            userImageUrl: i.userImageUrl,
                            imageUrl: i.imageUrl,
                            favorite: i.favorite,
                            favoriteNumber: i.favoriteNumber,
                            tags: i.tags)
            localItems.append(item)
        }
        return localItems
    }
}
