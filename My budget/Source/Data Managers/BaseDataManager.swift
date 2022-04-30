//
//  BaseDataManager.swift
//  My budget
//
//  Created by Николай Маторин on 20.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

class BaseDataManager<Entity: NSManagedObject>: DataManager {
    
    let context: NSManagedObjectContext?
    let persistentStoreCoordinator: NSPersistentStoreCoordinator?
    private var saveContextHandler: (() -> Void) = { }
    
    init() {
        saveContextHandler = {
            guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
            appDelegate.saveContext()
        }
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        context = appDelegate?.persistentContainer.viewContext
        persistentStoreCoordinator = appDelegate?.persistentContainer.persistentStoreCoordinator
    }
    
    func getObjects() -> [Entity] {
        
        var result = [Entity]()
        
        guard let request = Entity.fetchRequest() as? NSFetchRequest<Entity> else { return [] }
    
        do {
            result = try context?.fetch(request) ?? []
        } catch  {
            print(error as Any)
        }
        
        return result
    }
    
    func findObject(by url: URL) -> Entity? {
        var object: Entity?
        
        guard let objectId = context?.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        
        do {
            let existingObject = try context?.existingObject(with: objectId)
            object = existingObject as? Entity
        } catch  {
            //return nil
        }
        
        return object
    }
    
    func create() -> Entity? {
        guard let context = context else { return nil }
        let object = Entity(context: context)
        return object
    }
    
    func createArray() -> [Entity] {
        let array = [Entity]()
        return array
    }
    
    func add(object: Entity) {
        context?.insert(object)
    }
    
    func delete(object: Entity) {
        context?.delete(object)
        saveContext()
    }
    
    func saveContext() {
        saveContextHandler()
    }
    
    func discardChanges(object: Entity) {
        context?.refresh(object, mergeChanges: false)
    }
}
