//
//  DatabaseManager.swift
//  FinalProject
//
//  Created by Georgiana Tanase on 14/04/2018.
//  Copyright © 2018 Georgiana Tanase. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    private init() { }
    static var shared = DatabaseManager()
    
    var realm = try! Realm()
    
    func add<T: Persistable>(_ value: T, update: Bool) {
        realm.add(value.managedObject(), update: update)
    }
    
    func deleteData() {
        try! realm.write {
            realm.deleteAll()
            UserDefaults.standard.set(false, forKey: "imageExists")
        }
    }
}
