//
//  FetchTransactionsUseCase.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class Repository {
    let realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func fetch<T: Object>(_ type: T.Type) -> Results<T> {
        return realm.objects(type)
    }
    
    func find<T: Object>(_ type: T.Type, byID id: String) -> T? {
        return realm.object(ofType: type, forPrimaryKey: id)
    }
    
    func update(block: @escaping (() -> Void)) {
        do {
            try realm.write {
                block()
            }
        } catch let error {
            print("Failed to update data = \(error)")
        }
    }
    
    func save<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        } catch let error {
            print("Failed to save data = \(error)")
        }
    }
    
    func save<T: Object>(_ objects: [T]) {
        do {
            try realm.write {
                realm.add(objects, update: .modified)
            }
        } catch let error {
            print("Failed to save data = \(error)")
        }
    }
    
    func remove<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let error {
            print("Failed to remove data = \(error)")
        }
    }
    
    func remove<T: Object>(_ objects: [T]) {
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch let error {
            print("Failed to remove data = \(error)")
        }
    }
    
    func removeAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch let error {
            print("Failed to remove all data = \(error)")
        }
    }
}
