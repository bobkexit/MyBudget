//
//  CurrencyRepository.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

final class CurrencyRepository: BaseRepository {
    
    static let shared = CurrencyRepository()
    
    private init() {
        
    }

    private let realm = try! Realm()
    
    func getAll() -> [Currency] {
        return realm.objects(RealmCurrency.self).map { $0.entity }
    }
    
    func getById(id: String) -> Currency? {
        return realm.object(ofType: RealmCurrency.self, forPrimaryKey: id)?.entity
    }
    
    func create(item: Currency, completion: @escaping BaseRepository.completionHandler) {
        do {
            try realm.write {
                realm.add(RealmCurrency(entity: item))
                completion(nil)
            }
        } catch  {
             completion(error)
        }
    }
    
    func upadte(item: Currency, completion: @escaping BaseRepository.completionHandler) {
        do {
            try realm.write {
                realm.add(RealmCurrency(entity: item), update: true)
                completion(nil)
            }
        } catch  {
            completion(error)
        }
    }
    
    func delete(by id: String, completion: @escaping BaseRepository.completionHandler) {
        
        guard let item = realm.object(ofType: RealmCurrency.self, forPrimaryKey: id) else {
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
    
    func clean(completion: (Error?) -> Void) {
        do {
            try realm.write {
                realm.delete(realm.objects(RealmCurrency.self))
                completion(nil)
            }
        } catch  {
            completion(error)
        }
    }
    
    func filter(query: String) -> [Currency]  {
        let result = realm.objects(RealmCurrency.self).filter(query)
        return result.map { $0.entity }
    }
}

