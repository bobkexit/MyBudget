//
//  RealmRepository.swift
//  My budget
//
//  Created by Николай Маторин on 15.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRepository<T>: Repository where T: Object {
    typealias RealmEntityType = T
    
    private let realm = try! Realm()
    
    func insert(item: T, completion: @escaping Repository.completionHandler) {
        do {
            try realm.write {
                realm.add(item, update: false)
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
    
    func update(item: T, completion: @escaping Repository.completionHandler) {
        do {
            try realm.write {
                realm.add(item, update: true)
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }

    func getAll() -> [T] {
        return realm.objects(T.self).flatMap { $0 }
    }
    
    func get(byId id: String) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func get(filteredBy filter: String) -> [T] {
        return realm.objects(T.self).filter(filter).flatMap { $0 }
    }
    
    func clean(completion: (Error?) -> Void) {
        do {
            try realm.write {
                realm.delete(realm.objects(T.self))
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
    
    func delete(item: T, completion: @escaping Repository.completionHandler) {
        do {
            try realm.write {
                realm.delete(item)
                completion(nil)
            }
        } catch  {
            completion(error)
        }
    }
}

