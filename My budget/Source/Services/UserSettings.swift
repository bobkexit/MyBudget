//
//  GeneralSettings.swift
//  My budget
//
//  Created by Николай Маторин on 16.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

final class UserSettings {
    
    // MARK: - Singleton Declaration
    
    public static let defaults = UserSettings()
    
    private init() {
        
    }

    // MARK: - Type Alias
    
    typealias Keys = Constants.UserSettings.Keys
    typealias CategoryType = CategoryViewModel.CategoryType
    typealias AccountType = AccountViewModel.AccountType

   
    // MARK: - Constants

    private let userDefaults = UserDefaults.standard
    
    
    // MARK: - Properties
    
    var dataManager = DataManager.shared
    
    
    // MARK: - Read-Only Properties
    
    var сurrencyCode: String? {
        return userDefaults.string(forKey: Keys.defaultCurrencyCode)
    }
    
    var account: Account? {
        guard let accountId = userDefaults.string(forKey: Keys.defaultAccountId)  else {
            return nil
        }
        let account = dataManager.findObject(ofType: Account.self, byId: accountId)
        return account
    }
    
    var expenseCategory: Category? {
        guard let categoryId = userDefaults.string(forKey: Keys.defaultExpenseCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: Category.self, byId: categoryId)
        return category
    }
    
    var incomeCategory: Category? {
        guard let categoryId = userDefaults.string(forKey: Keys.defaultIncomeCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: Category.self, byId: categoryId)
        return category
    }
    
    var accountAdjustmentExpense: Category? {
        guard let categoryId = userDefaults.string(forKey: Keys.accountAdjustmentExpenseCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: Category.self, byId: categoryId)
        return category
    }
    
    var accountAdjustmentIncome: Category? {
        guard let categoryId = userDefaults.string(forKey: Keys.accountAdjustmentIncomeCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: Category.self, byId: categoryId)
        return category
    }
    
    
    // MARK: - Setters
    
    func setDefault(currencyCode: String) {
        userDefaults.set(currencyCode, forKey: Keys.defaultCurrencyCode)
    }
  
    func setDefault(accountId: String) {
        userDefaults.set(accountId, forKey: Keys.defaultAccountId)
    }
    
    func setDefault(expenseCategory categoryId: String) {
        set(categoryId, forCategoryType: .credit, andKey: Keys.defaultExpenseCategoryId)
    }
    
    func setDefault(incomeCategory categoryId: String) {
        set(categoryId, forCategoryType: .debit, andKey: Keys.defaultIncomeCategoryId)
    }
    
    func setExpenseAccountAdjustment(_ categoryId: String) {
        set(categoryId, forCategoryType: .credit, andKey: Keys.accountAdjustmentExpenseCategoryId)
    }
    
    func setIncomeAccountAdjustment(_ categoryId: String) {
        set(categoryId, forCategoryType: .debit, andKey: Keys.accountAdjustmentIncomeCategoryId)
    }
    
    
    // MARK: - Private Methods
    
    private func set(_ categoryId: String, forCategoryType categoryType: CategoryType, andKey key: String) {
        
        guard let category = dataManager.findObject(ofType: Category.self, byId: categoryId)  else {
            fatalError("Category with id = \(categoryId) not found")
        }
        
        guard CategoryType(rawValue: category.typeId) != categoryType else {
            fatalError("incorrect default category type")
        }
        
        userDefaults.set(categoryId, forKey: key)
    }
    
}
