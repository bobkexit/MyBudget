//
//  ViewModelFactory.swift
//  My budget
//
//  Created by Николай Маторин on 12.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

//protocol ViewModelFactoryProtocol {
//    func createAccountViewModel(object: Account, dataManager: BaseDataManager<Account>) -> AccountVM
//    func createCategoryViewModel(model: Category?) -> CategoryVM
//    func createTransactionViewModel(model: Transaction?) -> TransactionVM
//}

protocol ViewModel {
    
    associatedtype Entity: NSManagedObject
    
    var object: Entity { get }
    var dataManager: BaseDataManager<Entity> { get }
    
    init(object: Entity, dataManager: BaseDataManager<Entity>)
}

//protocol ViewModelFactoryProtocol {
//
//    associatedtype EntityType: NSManagedObject
//
//    func create<EntityType>(object: EntityType, dataManger: BaseDataManager<EntityType>) -> BaseViewModel<EntityType>
//}

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
    
    
    
    
//    public static let shared = ViewModelFactory()
//
//    private let dataManager = DataService.shared
//
//    func createAccountViewModel(mod) -> AccountVM {
//        var viewModel: AccountVM
//
//        if let model = model {
//            return AccountVM(model)
//        }
//
//        let account = dataManager.create(Account.self)
//        viewModel = AccountVM(account)
//
//        return viewModel
//    }
//
//    func createCategoryViewModel(model: Category? = nil) -> CategoryVM {
//        var viewModel: CategoryVM
//
//        if let model = model {
//            return CategoryVM(model)
//        }
//
//        let category = dataManager.create(Category.self)
//        viewModel = CategoryVM(category)
//
//        return viewModel
//    }
//
//    func createTransactionViewModel(model: Transaction? = nil) -> TransactionVM {
//        var viewModel: TransactionVM
//
//        if let model = model {
//            return TransactionVM(model)
//        }
//
//        let transaction = dataManager.create(Transaction.self)
//        viewModel = TransactionVM(transaction)
//
//        return viewModel
//    }
