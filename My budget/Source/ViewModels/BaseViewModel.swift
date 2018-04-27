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
    
    let dateFormatter = Helper.shared.createFormatter(for: .date) as! DateFormatter

    let currencyFormatter = Helper.shared.createFormatter(for: .currency) as! NumberFormatter
    
    let decimalFormatter = Helper.shared.createFormatter(for: .decimal) as! NumberFormatter
  
    required init(object: Entity, dataManager: BaseDataManager<Entity>) {
        self.object = object
        self.dataManager = dataManager
    }
    
    func save() {
        dataManager.saveContext()
    }
    
    func reset() {
        dataManager.discardChanges(object: object)
    }
    
    func set(_ value: Any?, forKey key: String) {
        object.setValue(value, forKey: key)
    }
    
    func delete() {
        dataManager.delete(object: object)
    }
    
   
}
