//
//  User.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 15/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import RealmSwift

public final class UserObject: Object {
    @objc dynamic var token = ""
    var favoriteimagesIDs = List<ImageIDObject>() //[ImageIDObject] = []
    
    override public static func primaryKey() -> String? {
        return "token"
    }
}

public final class  ImageIDObject: Object {
    @objc dynamic var id = 0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}

public struct User {
    public var token: String
    public var favoriteImagesIDs: [ImageID]
}

public struct ImageID {
    public var id: Int
}

extension User: Persistable {
    public typealias ManagedObject = UserObject
    
    public init(managedObject: UserObject) {
        token = managedObject.token
        favoriteImagesIDs = managedObject.favoriteimagesIDs.compactMap(ImageID.init(managedObject:))
    }
    
    public func managedObject() -> UserObject {
        let user = UserObject()
        
        user.token = token
        
        let ids = favoriteImagesIDs.compactMap{ $0.managedObject()}
        
        let pizdamaszii = List<ImageID>()
        for i in ids {
            pizdamaszii
        }
        user.favoriteimagesIDs = ids.map (ids) { mapper.map($0) }
        
        return user
    }
}

extension ImageID: Persistable {
    public typealias ManagedObject = ImageIDObject
    
    public init(managedObject: ImageIDObject) {
        id = managedObject.id
    }
    
    public func managedObject() -> ImageIDObject {
        let imageID = ImageIDObject()
        
        imageID.id = id
        
        return imageID
    }
}
