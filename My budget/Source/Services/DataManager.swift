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
    static let shared = DataManager()
    
    private init() {
        
    }
    
    private let realm = try! Realm()
    
    func getData<T: Object>(of type: T.Type) -> Results<T> {
        return realm.objects(T.self)
    }
    
    func createOrUpdate(data: Object)  {
        do {
            try realm.write {
                realm.add(data, update: true)
            }
        } catch  {
            print(error as Any)
        }
    }
    
    func createOrUpdate(data: [Object]) {
        do {
            try realm.write {
                realm.add(data, update: true)
            }
        } catch  {
            print(error as Any)
        }
    }
    
    func remove(data: Object) {
        do {
            try realm.write {
                 realm.delete(data)
            }
        } catch  {
            print(error as Any)
        }
    }
    
    func removeAllData<T: Object>(of type: T.Type)  {
        do {
            let data = getData(of: T.self)
            try realm.write {
                realm.delete(data)
            }
        } catch  {
            print(error as Any)
        }
    }
}
