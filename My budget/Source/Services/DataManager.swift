//
//  DataManager.swift
//  My budget
//
//  Created by Николай Маторин on 25.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

final class DataManager {
    typealias completionHandler = (_ error: Error?) -> ()
    
    static let shared = DataManager()
    
    private let realm = try! Realm()
    
    private init() {
        
    }
    
    func fetchObjects<T: Object>(ofType type: T.Type) -> Results<T> {
        let objects = realm.objects(T.self)
        return objects
    }
    
    func findObject<T: Object>(ofType type: T.Type, byId id: String) -> T? {
        guard let primaryKey = T.primaryKey() else {
            return nil
        }
        
        var objects = realm.objects(T.self)
        objects = objects.filter("\(primaryKey) = '\(id)'")
        
        return objects.first
    }
    
    //FIXME: - remove method
    func findObject<T: Object>(ofType type: T.Type, byValue value: String, ofKey key: String ) -> T? {
        var objects = realm.objects(T.self)
        objects = objects.filter("\(key) = '\(value)'")
        return objects.first
    }
    
    func createObject<T: Object>(ofType type: T.Type) -> T {
        return T()
    }
    
    func object(_ object: Object, setValue vale: Any?, forKey key: String) {
        do {
            try realm.write {
                object.setValue(vale, forKeyPath: key)
                notifyObjectHasChaned(object: object)
            }
        } catch  {
            print(error as Any)
        }
    }
    
    func save(_ object: Object) {
        do {
            try realm.write {
                realm.add(object, update: true)
                notifyObjectHasChaned(object: object)
            }
        } catch  {
            print(error as Any)
        }
    }
    
    func remove(_ object: Object,_ completion: @escaping completionHandler) {
        do {
            try realm.write {
                realm.delete(object)
                // FIXME: - should notify, but object has been deleted
                completion(nil)
            }
        } catch  {
            print(error as Any)
            completion(error)
        }
    }
    
    private func notifyObjectHasChaned(object: Object) {
        if object is Account {
            NotificationCenter.default.post(name: .account, object: nil)
        } else if object is Transaction {
            NotificationCenter.default.post(name: .transaction, object: nil)
        } else if object is Category {
            
        }
    }
}
