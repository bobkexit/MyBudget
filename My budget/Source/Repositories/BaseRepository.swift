//
//  BaseRepository.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

protocol Entity {
    
}

protocol RealmEntity {
    associatedtype EntityType
    
    init(entity: EntityType)
    var entity: EntityType { get }
}

protocol Repository {
    associatedtype EntityType
    
    typealias completionHandler = (_ error: Error?) -> Void
    
    func getAll() -> [EntityType]
    func get(byId id: String) -> EntityType?
    func get(filteredBy filter: String) -> [EntityType]
    func insert(item: EntityType, completion: @escaping completionHandler)
    func delete(item: EntityType, completion: @escaping completionHandler)
    func clean(completion: completionHandler)
    
}

//protocol BaseRepository {
//    associatedtype T
//    
//    typealias completionHandler = (_ error: Error?) -> Void
//    
//    func getAll() -> [T]
//    func getById(id: String) -> T?
//    func create(item: T, completion: @escaping completionHandler)
//    func upadte(item: T, completion: @escaping completionHandler)
//    func delete(by id: String, completion: @escaping completionHandler)
//    func clean(completion: completionHandler)
//}




