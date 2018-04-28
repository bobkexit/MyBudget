//
//  GeneralSettings.swift
//  My budget
//
//  Created by Николай Маторин on 16.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

final class UserSettings {
    
    typealias Keys = Constants.UserSettings.Keys
    
    typealias BuildInData = Constants.UserSettings.BuildInData
   
    lazy var accountManager = BaseDataManager<Account>()
    
    lazy var categoryManager = BaseDataManager<Category>()
    
    lazy var incomeCategoryManager = IncomeCategoryManager()
    
    lazy var expenseCategoryManager = ExpenseCategoryManager()
    
    // MARK: - Pivate Properties
    
    private let userDefaults = UserDefaults.standard
    
    
    // MARK: - Public Properties
    
    public static let defaults = UserSettings()
    
    var сurrencyCode: String? {
        return userDefaults.string(forKey: Keys.defaultCurrencyCode)
    }
    
    var account: Account? {
        guard let url = userDefaults.url(forKey: Keys.defaultAccountId)  else {
            return nil
        }
        
        let object = accountManager.findObject(by: url)
        
        return object
    }
    
    var expenseCategory: Category? {
        guard let url = userDefaults.url(forKey: Keys.defaultExpenseCategoryId)  else {
            return nil
        }
        
        let object = expenseCategoryManager.findObject(by: url)
        
        return object
    }
    
    var incomeCategory: Category? {
        guard let url = userDefaults.url(forKey: Keys.defaultIncomeCategoryId)  else {
            return nil
        }
        
        let object = incomeCategoryManager.findObject(by: url)
        
        return object
    }
    
    var initialBalance: Category? {
        guard let url = userDefaults.url(forKey: BuildInData.initialBalanceId)  else {
            return nil
        }
        
        let object = incomeCategoryManager.findObject(by: url)
        
        return object
    }
    
    // MARK: - Initializer
    
    private init() {
        
    }
    
    // MARK: - Methods
    
    func defaultCategory(forCategoryType categoryType: CategoryType) -> Category? {
        
        var url: URL?
        
        switch categoryType {
        case .credit:
            url = userDefaults.url(forKey: Keys.defaultExpenseCategoryId)
        case .debit:
            url = userDefaults.url(forKey: Keys.defaultIncomeCategoryId)
        }
        
        guard let categoryUrl = url else {
            return nil
        }
        
        let category = categoryManager.findObject(by: categoryUrl)
        
        return category
    }
    
    // MARK: - Setters
    
    func set(defaultCurrencyCode currencyCode: String) {
        userDefaults.set(currencyCode, forKey: Keys.defaultCurrencyCode)
    }
    
    func set(defautAccount account: Account) {
        let url = account.objectID.uriRepresentation()
        userDefaults.set(url, forKey: Keys.defaultAccountId)
    }
    
    func set(defaultCategory category: Category) {
        
        let url = category.objectID.uriRepresentation()
        
        if Int(category.typeId) == CategoryType.debit.rawValue {
            userDefaults.set(url, forKey: Keys.defaultIncomeCategoryId)
        } else if Int(category.typeId) == CategoryType.credit.rawValue {
            userDefaults.set(url, forKey: Keys.defaultExpenseCategoryId)
        }
    }
}
