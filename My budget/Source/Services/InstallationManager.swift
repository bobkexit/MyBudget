//
//  DataService.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

final class InstallationManager {
    
    // MARK: - Singleton Declaration
    
    public static let shared = InstallationManager()
    
    private init() {
    
    }
    
    
    // MARK: - Type Alias
    
    typealias CategoryType = BaseViewModel.CategoryType
    typealias Kyes = UserSettings.Keys
    
    // MARK: - Public Properties
    
    var viewModelFactory = ViewModelFactory.shared
    
    
    // MARK: - Constants
    
    private let userDefaults = UserDefaults.standard
    private let userSettings = UserSettings.defaults
    
    
    // MARK: - Internal Methods
    
    func installDataIfNeeded()  {
        
        if userDefaults.bool(forKey: Kyes.firstLaunch) { return }
        
        setDefaultCurrency()
        
        createAccounts()
        createIncomes()
        createExpenses()
        
        userDefaults.set(true, forKey: Kyes.firstLaunch)
    }
    
    
    // MARK: - Default Currency Setter
    
    fileprivate func setDefaultCurrency() {
        guard let currencyCode = Locale.current.currencyCode else { return }
        userSettings.setDefault(currencyCode: currencyCode)
    }
    
    // MARK: - Creation Methods
    
    fileprivate func createAccounts() {
        let cashId = createCashAccount()
        userSettings.setDefault(accountId: cashId)
    }
    
    fileprivate func createExpenses() {
        let _ = createProductCategory()
        let _ = createHealthCategory()
        let _ = createUtilitiesCategory()
        let _ = createEntertainmentCategory()
        
        let accountAdjustmentId = createAccountAdjustment(.credit)
        userSettings.setExpenseAccountAdjustment(accountAdjustmentId)
    }
        
    fileprivate func createIncomes() {
        let salaryId = createSalaryCategory()
        let accountAdjustmentId = createAccountAdjustment(.debit)
        
        userSettings.setDefault(incomeCategory: salaryId)
        userSettings.setIncomeAccountAdjustment(accountAdjustmentId)
    }
    
    
    // MARK: - Build-in Accounts
    
    fileprivate func createCashAccount() -> String {
        let account = viewModelFactory.createAccountViewModel()
        account.set(title: "Cash")
        account.set(accountType: .cash)
        account.save()
        
        return account.id
    }
   
    
    // MARK: - Build-in Special Category
    
    fileprivate func createAccountAdjustment(_ categoryType: CategoryType) -> String {
        let category = viewModelFactory.createCategoryViewModel()
        category.set(title: "Account adjustment")
        category.set(categoryType: categoryType)
        category.save()
        
        return category.id
    }
    
    
    // MARK: Build-in Incomes
    
    fileprivate func createSalaryCategory() -> String {
        let category = viewModelFactory.createCategoryViewModel()
        category.set(title: "Salary")
        category.set(categoryType: .debit)
        category.save()
        
        return category.id
    }
    
    
    // MARK: Build-in Expenses
    
    fileprivate func createProductCategory() -> String {
        let category = viewModelFactory.createCategoryViewModel()
        category.set(title: "Products")
        category.set(categoryType: .credit)
        category.save()
        
        return category.id
    }
    
    fileprivate func createHealthCategory() -> String {
        let category = viewModelFactory.createCategoryViewModel()
        category.set(title: "Health")
        category.set(categoryType: .credit)
        category.save()
        
        return category.id
    }
    
    fileprivate func createUtilitiesCategory() -> String {
        let category = viewModelFactory.createCategoryViewModel()
        category.set(title: "Utilities")
        category.set(categoryType: .credit)
        category.save()
        
        return category.id
    }
    
    fileprivate func createEntertainmentCategory() -> String {
        let category = viewModelFactory.createCategoryViewModel()
        category.set(title: "Entertainment")
        category.set(categoryType: .credit)
        category.save()
        
        return category.id
    }
}
