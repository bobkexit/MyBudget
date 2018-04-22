//
//  BaseViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

class BaseViewModel<Entity: NSManagedObject>: ViewModel {
    
    var object: Entity
    let dataManager: BaseDataManager<Entity>
    
    required init(object: Entity, dataManager: BaseDataManager<Entity>) {
        self.object = object
        self.dataManager = dataManager
    }
    
    func save() {
        //dataManager.add(object: object)
        dataManager.saveContext()
    }
    
    func delete() {
        dataManager.delete(object: object)
    }
}
