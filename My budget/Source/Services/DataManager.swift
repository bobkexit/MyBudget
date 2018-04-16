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
    
    // MARK: - Singleton Declaration
    
    static let shared = DataManager()
    
    private init() {
        
    }
    
    // MARK: - Type Alias
    typealias completionHandler = (_ error: Error?) -> ()
    
    // MARK: - Constants
    private let realm = try! Realm()
    
    
    // MARK: - Read Methods
    
    func fetchObjects<T: Object>(ofType type: T.Type, filteredBy query: String? = nil) -> Results<T> {
        var objects = realm.objects(T.self)
        
        if let query = query {
            objects = objects.filter(query)
        }
        
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
    
    
    // MARK: - Create Methods
    
    func createObject<T: Object>(ofType type: T.Type) -> T {
        return T()
    }
    
   
    // MARK: - Update Methods
    
    func object(_ object: Object, setValue vale: Any?, forKey key: String) {
        do {
            try realm.write {
                object.setValue(vale, forKeyPath: key)
            }
        } catch  {
            print(error as Any)
        }
    }
    
    func save(_ object: Object, _ completion: completionHandler? = nil) {
        do {
            try realm.write {
                
                realm.add(object, update: true)
                
                if let completion = completion {
                    completion(nil)
                }
            }
        } catch  {
            print(error as Any)
            
            if let completion = completion {
                completion(error)
            }
        }
    }
    
   
    // MARK: - Delete Methods
    
    func remove(_ object: Object, _ completion: completionHandler? = nil) {
        do {
            try realm.write {
                
                realm.delete(object)
                
                if let completion = completion {
                    completion(nil)
                }
            }
        } catch  {
            print(error as Any)
            
            if let completion = completion {
                completion(error)
            }
        }
    }
}
