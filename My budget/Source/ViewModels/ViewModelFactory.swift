//
//  ViewModelFactory.swift
//  My budget
//
//  Created by Николай Маторин on 12.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

protocol ViewModelFactoryProtocol {
    func createAccountViewModel(model: RealmAccount?) -> AccountViewModel
    func createCategoryViewModel(model: RealmCategory?) -> CategoryViewModel
    func createTransactionViewModel(model: RealmTransaction?) -> TransactionViewModel
}


final class ViewModelFactory: ViewModelFactoryProtocol {
    public static let shared = ViewModelFactory()
    
    private let dataManager = RealmDataManager.shared
    
    func createAccountViewModel(model: RealmAccount? = nil) -> AccountViewModel {
        var viewModel: AccountViewModel
        
        if let model = model {
            return AccountViewModel(withAccount: model)
        }
        
        let account = RealmAccount() //dataManager.createObject(ofType: Account.self)
        viewModel = AccountViewModel(withAccount: account)
        
        return viewModel
    }
    
    func createCategoryViewModel(model: RealmCategory? = nil) -> CategoryViewModel {
        var viewModel: CategoryViewModel
        
        if let model = model {
            return CategoryViewModel(withCategory: model)
        }
        
        let category = RealmCategory() //dataManager.createObject(ofType: Category.self)
        viewModel = CategoryViewModel(withCategory: category)
        
        return viewModel
    }
    
    func createTransactionViewModel(model: RealmTransaction? = nil) -> TransactionViewModel {
        var viewModel: TransactionViewModel
        
        if let model = model {
            return TransactionViewModel(withTransaction: model)
        }
        
        let transaction = RealmTransaction() //dataManager.createObject(ofType: Transaction.self)
        viewModel = TransactionViewModel(withTransaction: transaction)
        
        return viewModel
    }
}
