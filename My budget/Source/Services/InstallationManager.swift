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
    
    static let shared = InstallationManager()
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Initializer
    
    private init() { }
    
    // MARK: - Public Methods
    
    func installDataIfNeeded()  {
        
        if userDefaults.url(forKey: BuildInData.initialBalanceId) == nil {
            createIncomeCategory(title: Localization.initialAccountBalance) { (objectId) in
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
        createAccount(title: Localization.cash.capitalizingFirstLetter, type: .cash, setDefault: true)
    
        // Create income categories
        createIncomeCategory(title: Localization.salary) { (objectId) in
            self.userDefaults.set(objectId, forKey: Kyes.defaultIncomeCategoryId)
        }
        
        // Create expense categories
        createExpenseCategory(title: Localization.products) { (objectId) in
            self.userDefaults.set(objectId, forKey: Kyes.defaultExpenseCategoryId)
        }
        
        createExpenseCategory(title: Localization.health)
        createExpenseCategory(title: Localization.utilities)
        createExpenseCategory(title: Localization.entertainment)
        
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
