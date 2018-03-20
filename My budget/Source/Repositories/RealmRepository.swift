//
//  RealmRepository.swift
//  My budget
//
//  Created by Николай Маторин on 15.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmRepository<T>: Repository where T: RealmEntity, T: Object, T.EntityType: Entity {
    typealias RealmEntityType = T
    
    private let realm = try! Realm()
    
    private func createInstance<T:RealmEntity>(type: T.Type, entity: T.EntityType) -> T {
        return T(entity: entity)
    }
    
    func insert(item: T.EntityType, update: Bool, completion: @escaping Repository.completionHandler) {
        
        let realmEntity = createInstance(type: T.self, entity: item)
        
        do {
            try realm.write {
                realm.add(realmEntity, update: update)
                completion(nil)
            }
        } catch {
            completion(error)
        }
    }
    
    func getAll() -> [T.EntityType] {
        return realm.objects(T.self).flatMap { $0.entity }
    }
    
    func get(byId id: String) -> T.EntityType? {
        return realm.object(ofType: T.self, forPrimaryKey: id)?.entity
    }
    
    func get(filteredBy filter: String) -> [T.EntityType] {
        return realm.objects(T.self).filter(filter).flatMap { $0.entity }
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
    
    func delete(by id: String, completion: @escaping Repository.completionHandler) {
        guard let item = realm.object(ofType: T.self, forPrimaryKey: id) else {
            return
        }
        
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

