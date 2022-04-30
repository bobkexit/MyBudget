//
//  ViewModelFactory.swift
//  My budget
//
//  Created by Николай Маторин on 12.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

protocol SomeViewModel: AnyObject {
    
    func save()
    
    func reset()
    
    func delete()
    
    func set(_ value: Any?, forKey key: String)
}

protocol ViewModel: SomeViewModel {
    
    associatedtype Entity: NSManagedObject
    
    var object: Entity { get }
    var dataManager: BaseDataManager<Entity> { get }
    
    init(object: Entity, dataManager: BaseDataManager<Entity>)
}

final class ViewModelFactory {
    
    static let shared = ViewModelFactory()
    
    private init() {
        
    }
    
    func create(object: Account, dataManager: BaseDataManager<Account>, isNew: Bool = false) -> AccountVM {
        isNew
            ? CreateAccountVM(object: object, dataManager: dataManager)
            : AccountVM(object: object, dataManager: dataManager)
    }
    
    func create(object: Category, dataManager: BaseDataManager<Category>) -> CategoryVM {
        CategoryVM(object: object, dataManager: dataManager)
    }
    
    func create(object: Transaction, dataManager: BaseDataManager<Transaction>) -> TransactionVM {
        object.isInserted
            ? TransactionVM(object: object, dataManager: dataManager)
            : UpdatedTransactionVM(object: object, dataManager: dataManager)
    }
}
