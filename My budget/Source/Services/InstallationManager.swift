//
//  DataService.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

final class InstallationManager {
    
    typealias Kyes = UserSettings.Keys
    
    // MARK: - Properties
    
    public static let shared = InstallationManager()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Initializer
    
    private init() {
    
    }
    
    // MARK: - Public Methods
    
    public func installDataIfNeeded()  {
        
        if userDefaults.bool(forKey: Kyes.firstLaunch) {
            return
        }
        
        if let currencyCode = Locale.current.currencyCode {
            userDefaults.set(currencyCode, forKey: Kyes.defaultCurrencyCode)
        }
        
        // Create account
        createAccount(title: "Cash", type: .cash, setDefault: true)
    
        // Create income categories
        createIncomeCategory(title: "Salary", setDefault: true)
        
        // Create expense categories
        createExpenseCategory(title: "Products", setDefault: true)
        createExpenseCategory(title: "Helath")
        createExpenseCategory(title: "Utilities")
        createExpenseCategory(title: "Entertainment")
        
        userDefaults.set(true, forKey: Kyes.firstLaunch)
    }
    
    // MARK: - Private Methods
    
    private func createAccount(title: String, type: AccountType, setDefault: Bool = false) {
        
        let dataManager = BaseDataManager<Account>()
        
        let account = dataManager.create()
        account.title = title
        account.typeId = Int16(type.rawValue)
        
        dataManager.saveContext()
        
        if setDefault {
            let url = account.objectID.uriRepresentation()
            userDefaults.set(url, forKey: Kyes.defaultAccountId)
        }
    }
    
    private func createIncomeCategory(title: String, setDefault: Bool = false) {
        
        let dataManager = IncomeCategoryManager()
        
        let category = dataManager.create()
        category.title = title
        
        dataManager.saveContext()
        
        if setDefault {
            let url = category.objectID.uriRepresentation()
            userDefaults.set(url, forKey: Kyes.defaultIncomeCategoryId)
        }
    }
    
    private func createExpenseCategory(title: String, setDefault: Bool = false) {
        
        let dataManager = ExpenseCategoryManager()
        
        let category = dataManager.create()
        category.title = title
        
        dataManager.saveContext()
        
        if setDefault {
            let url = category.objectID.uriRepresentation()
            userDefaults.set(url, forKey: Kyes.defaultExpenseCategoryId)
        }
    }
}
