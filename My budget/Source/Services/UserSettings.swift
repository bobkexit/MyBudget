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
    
    var dataManager = RealmDataManager.shared
    
    
    // MARK: - Read-Only Properties
    
    var сurrencyCode: String? {
        return userDefaults.string(forKey: Keys.defaultCurrencyCode)
    }
    
    var account: RealmAccount? {
        guard let accountId = userDefaults.string(forKey: Keys.defaultAccountId)  else {
            return nil
        }
        let account = dataManager.findObject(ofType: RealmAccount.self, byId: accountId)
        return account
    }
    
    var expenseCategory: RealmCategory? {
        guard let categoryId = userDefaults.string(forKey: Keys.defaultExpenseCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: RealmCategory.self, byId: categoryId)
        return category
    }
    
    var incomeCategory: RealmCategory? {
        guard let categoryId = userDefaults.string(forKey: Keys.defaultIncomeCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: RealmCategory.self, byId: categoryId)
        return category
    }
    
    var accountAdjustmentExpense: RealmCategory? {
        guard let categoryId = userDefaults.string(forKey: Keys.accountAdjustmentExpenseCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: RealmCategory.self, byId: categoryId)
        return category
    }
    
    var accountAdjustmentIncome: RealmCategory? {
        guard let categoryId = userDefaults.string(forKey: Keys.accountAdjustmentIncomeCategoryId)  else {
            return nil
        }
        let category = dataManager.findObject(ofType: RealmCategory.self, byId: categoryId)
        return category
    }
    
    
    // MARK: - Setters
    
    func setDefault(currencyCode: String) {
        userDefaults.set(currencyCode, forKey: Keys.defaultCurrencyCode)
    }
  
    func setDefault(accountId: String) {
        userDefaults.set(accountId, forKey: Keys.defaultAccountId)
    }
    
    func setDefault(categoryId: String, forCategoryType categoryType: CategoryType, andKey key: String) {
      
        guard let category = dataManager.findObject(ofType: RealmCategory.self, byId: categoryId) else {
            fatalError("Category with id = \(categoryId) not found")
        }
        
        
        guard CategoryType(rawValue: category.typeId) != categoryType else {
            fatalError("incorrect default category type")
        }
        
        userDefaults.set(categoryId, forKey: key)
    }
}
