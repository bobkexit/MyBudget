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
    typealias BuildInData = Constants.UserSettings.BuildInData
    
    typealias CompletionHandler = (_ objectId: URL) -> ()
    
    
    // MARK: - Properties
    
    public static let shared = InstallationManager()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Initializer
    
    private init() {
    
    }
    
    // MARK: - Public Methods
    
    public func installDataIfNeeded()  {
        
       
        
        if userDefaults.url(forKey: BuildInData.initialBalanceId) == nil {
            createIncomeCategory(title: NSLocalizedString("Initial account balance", comment: "")) { (objectId) in
                self.userDefaults.set(objectId, forKey: BuildInData.initialBalanceId)
            }
        }
        
        if userDefaults.bool(forKey: Kyes.firstLaunch) {
            return
        }
        
        if let currencyCode = Locale.current.currencyCode {
            userDefaults.set(currencyCode, forKey: Kyes.defaultCurrencyCode)
        }
        
        // Create account
        createAccount(title: NSLocalizedString("Cash", comment: ""), type: .cash, setDefault: true)
    
        // Create income categories
        createIncomeCategory(title: NSLocalizedString("Salary", comment: "")) { (objectId) in
            self.userDefaults.set(objectId, forKey: Kyes.defaultIncomeCategoryId)
        }
        
        // Create expense categories
        createExpenseCategory(title: NSLocalizedString("Products", comment: "")) { (objectId) in
            self.userDefaults.set(objectId, forKey: Kyes.defaultExpenseCategoryId)
        }
        
        createExpenseCategory(title: NSLocalizedString("Health", comment: ""))
        createExpenseCategory(title: NSLocalizedString("Utilities", comment: ""))
        createExpenseCategory(title: NSLocalizedString("Entertainment", comment: ""))
        
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
    
    private func createIncomeCategory(title: String, _ completion: CompletionHandler? = nil) {
        
        let dataManager = IncomeCategoryManager()
        
        let category = dataManager.create()
        category.title = title
        
        dataManager.saveContext()
        
        if let completion = completion {
            let url = category.objectID.uriRepresentation()
            completion(url)
        }
    }
    
    private func createExpenseCategory(title: String, _ completion: CompletionHandler? = nil) {
        
        let dataManager = ExpenseCategoryManager()
        
        let category = dataManager.create()
        category.title = title
        
        dataManager.saveContext()
        
        if let completion = completion {
            let url = category.objectID.uriRepresentation()
            completion(url)
        }
    }
}
