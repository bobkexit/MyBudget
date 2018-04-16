//
//  ViewModelFactory.swift
//  My budget
//
//  Created by Николай Маторин on 12.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

protocol ViewModelFactoryProtocol {
    func createAccountViewModel(model: Account?) -> AccountViewModel
    func createCategoryViewModel(model: Category?) -> CategoryViewModel
    func createTransactionViewModel(model: Transaction?) -> TransactionViewModel
}


final class ViewModelFactory: ViewModelFactoryProtocol {
    public static let shared = ViewModelFactory()
    
    private let dataManager = DataManager.shared
    
    func createAccountViewModel(model: Account? = nil) -> AccountViewModel {
        var viewModel: AccountViewModel
        
        if let model = model {
            return AccountViewModel(withAccount: model)
        }
        
        let account = dataManager.createObject(ofType: Account.self)
        viewModel = AccountViewModel(withAccount: account)
        
        return viewModel
    }
    
    func createCategoryViewModel(model: Category? = nil) -> CategoryViewModel {
        var viewModel: CategoryViewModel
        
        if let model = model {
            return CategoryViewModel(withCategory: model)
        }
        
        let category = dataManager.createObject(ofType: Category.self)
        viewModel = CategoryViewModel(withCategory: category)
        
        return viewModel
    }
    
    func createTransactionViewModel(model: Transaction? = nil) -> TransactionViewModel {
        var viewModel: TransactionViewModel
        
        if let model = model {
            return TransactionViewModel(withTransaction: model)
        }
        
        let transaction = dataManager.createObject(ofType: Transaction.self)
        viewModel = TransactionViewModel(withTransaction: transaction)
        
        return viewModel
    }
}
