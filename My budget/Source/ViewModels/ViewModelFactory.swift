//
//  ViewModelFactory.swift
//  My budget
//
//  Created by Николай Маторин on 12.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

protocol ViewModel {
    
    associatedtype Entity: NSManagedObject
    
    var object: Entity { get }
    var dataManager: BaseDataManager<Entity> { get }
    
    init(object: Entity, dataManager: BaseDataManager<Entity>)
}

final class ViewModelFactory {
    
    public static let shared = ViewModelFactory()
    
    private init() {
        
    }
    
    func create(object: Account, dataManager: BaseDataManager<Account>) -> AccountVM {
        return AccountVM(object: object, dataManager: dataManager)
    }
    
    func create(object: Category, dataManager: BaseDataManager<Category>) -> CategoryVM {
        return CategoryVM(object: object, dataManager: dataManager)
    }
    
    func create(object: Transaction, dataManager: BaseDataManager<Transaction>) -> TransactionVM {
        return TransactionVM(object: object, dataManager: dataManager)
    }
}
