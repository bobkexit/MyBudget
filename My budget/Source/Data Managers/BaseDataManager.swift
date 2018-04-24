//
//  BaseDataManager.swift
//  My budget
//
//  Created by Николай Маторин on 20.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

class BaseDataManager<Entity: NSManagedObject>: DataManager{
    
    private let appDelegate: AppDelegate
    let context: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    
    init() {
        
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            fatalError("can't find AppDelegate")
        }
        
        self.appDelegate = appDelegate
        self.context = appDelegate.persistentContainer.viewContext
        self.persistentStoreCoordinator = appDelegate.persistentContainer.persistentStoreCoordinator
    }
    
    func getObjects() -> [Entity] {
        
        var result = [Entity]()
        
        let request: NSFetchRequest<Entity> = Entity.fetchRequest() as! NSFetchRequest<Entity>
    
        do {
            result = try context.fetch(request)
        } catch  {
            print(error as Any)
        }
        
        return result
    }
    
    func findObject(by url: URL) -> Entity? {
        var object: Entity?
        
        let coordinator = context.persistentStoreCoordinator
        
        guard let objectId = coordinator?.managedObjectID(forURIRepresentation: url) else {
            return nil
        }
        
        do {
            let existingObject = try context.existingObject(with: objectId)
            object = existingObject as? Entity
        } catch  {
            //return nil
        }
        
        return object
    }
    
    func create() -> Entity {
        let object = Entity(context: context)
        return object
    }
    
    func createArray() -> [Entity] {
        let array = [Entity]()
        return array
    }
    
    func add(object: Entity) {
        context.insert(object)
    }
    
    func delete(object: Entity) {
        context.delete(object)
        self.saveContext()
    }
    
    func saveContext() {
        appDelegate.saveContext()
    }
    
    func discardChanges(object: Entity) {
        context.refresh(object, mergeChanges: false)
    }
}
