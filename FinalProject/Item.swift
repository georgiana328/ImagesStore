//
//  Item.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}

public final class ItemObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var userName = ""
    @objc dynamic var userImageUrl = ""
    @objc dynamic var imageUrl = ""
    @objc dynamic var favorite = false
    @objc dynamic var favoriteNumber = 0
    @objc dynamic var tags = ""
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

public struct Item {
    public var id: Int
    public var userName: String
    public var userImageUrl: String
    public var imageUrl: String
    public var favorite: Bool
    public var favoriteNumber: Int
    public var tags: String
}

extension Item: Persistable {
    public typealias ManagedObject = ItemObject
    
    public init(managedObject: ItemObject) {
        id = managedObject.id
        userName = managedObject.userName
        userImageUrl = managedObject.userImageUrl
        imageUrl = managedObject.imageUrl
        favorite = managedObject.favorite
        favoriteNumber = managedObject.favoriteNumber
        tags = managedObject.tags
    }
    
    public func managedObject() -> ItemObject {
        let item = ItemObject()
        item.id = id
        item.userName = userName
        item.userImageUrl = userImageUrl
        item.imageUrl = imageUrl
        item.favorite = favorite
        item.favoriteNumber = favoriteNumber
        item.tags = tags
        
        return item
    }
}
