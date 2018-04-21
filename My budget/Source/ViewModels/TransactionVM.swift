//
//  TransactionViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class TransactionVM: BaseViewModel<Transaction> {
    
    // MARK: - Private Properties
    
    private var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter
    }
    
    // MARK: - Public Properties
    
    var operationType: CategoryType = .credit
    
    var id: URL {
        return self.object.objectID.uriRepresentation()
    }
    
    var account: String? {
        let account = self.object.account
        return account?.title
    }
    
    var accountType: AccountType? {
        guard let accountTypeId = self.object.account?.typeId else {
            return nil
        }
        return AccountType(rawValue: Int(accountTypeId))
    }
    
    var category: String? {
        let category = self.object.category
        return category?.title
    }
    
    
    var categoryType: CategoryType? {
        guard let categoryTypeId = self.object.category?.typeId else {
            return nil
        }
        return CategoryType(rawValue: Int(categoryTypeId))
    }
    
    var date: String {
       
        let value = self.dateFormatter.string(from: self.object.date!)
        return value
    }
    
    var comment: String? {
        return self.object.comment
    }
    
    var amount: String? {
        let number = NSNumber(value: self.object.amount)
        let value = numberFormatter.string(from: number)
        return value
    }
    
    var currencyAmount: String? {
        guard let currencyCode = UserSettings.defaults.сurrencyCode else {
            return nil
        }
        
        let local = NSLocale(localeIdentifier: currencyCode)
        
        guard let currencySymbol = local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode) else {
            return nil
        }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.currencySymbol = currencySymbol
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.numberStyle = .currency
        
        let number = NSNumber(value: self.object.amount)
        let value = currencyFormatter.string(from: number)
        
        return value
    }
    
    // MARK: - Setters
    
    func set(date: String) {
        guard let value = self.dateFormatter.date(from: date) else {
            return
        }
        self.object.date = value
    }
    
    func set(date: Date) {
        self.object.date = date
    }
    
    func set(account: Account) {
        object.account = account
    }
    
    func set(category: Category) {
        object.category = category
    }
    
    func set(amount: String?) {
        guard let amount = amount, !amount.isEmpty else {
            return
        }
        
        guard let nummber = numberFormatter.number(from: amount) else {
            return
        }
        
        object.amount = nummber.floatValue
    }
    
    func set(amount: Float) {
        object.amount = amount
    }
    
    func set(comment: String?) {
        object.comment = comment
    }
}
