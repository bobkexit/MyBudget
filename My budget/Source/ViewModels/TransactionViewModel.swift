//
//  TransactionViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
struct TransactionViewModel {
    typealias Entity = Transaction
    typealias AccountType = BaseViewModel.AccountType
    typealias CategoryType = BaseViewModel.CategoryType
    typealias CompletionHandler = (_ error: Error?) -> ()
    
    private let transaction: Entity
    private let dataManager = DataManager.shared
   
    init(withTransaction transaction: Entity) {
        self.transaction = transaction
      
        if let categoryTypeId = transaction.category?.typeId, let categoryType = CategoryType(rawValue: categoryTypeId) {
            self.operationType = categoryType
        } else {
            self.operationType = .credit
        }
    }
    
    var id: String {
        return self.transaction.id
    }
    
    var account: String? {
        let account = self.transaction.account
        return account?.title
    }
    
    var accountType: AccountType? {
        guard let account = self.transaction.account else {
            return nil
        }
        return AccountType(rawValue: account.typeId)
    }
    
    var category: String? {
        let category = self.transaction.category
        return category?.title
    }
    
    var operationType: CategoryType
    
    var categoryType: CategoryType? {
        guard let categoryTypeId = self.transaction.category?.typeId else {
            return nil
        }
        return CategoryType(rawValue: categoryTypeId)
    }
    
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let value = dateFormatter.string(from: self.transaction.date)
        return value
    }
    
    var comment: String? {
        return self.transaction.comment
    }
    
    var currencyCode: String? {
        let account = self.transaction.account
        return account?.currencyCode
    }
    
    var currencySymbol: String? {
        guard let currencyCode = self.currencyCode else {
            return nil
        }
        let local = NSLocale(localeIdentifier: currencyCode)
        let symbol = local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode)
        return symbol
    }
    
    var amount: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        if let currencySymbol = self.currencySymbol, let currencyCode = self.currencyCode  {
            numberFormatter.currencySymbol = currencySymbol
            numberFormatter.currencyCode = currencyCode
            numberFormatter.numberStyle = .currency
        } else {
            numberFormatter.numberStyle = .decimal
        }
        
        let sum = self.transaction.amount * (self.operationType == .credit ? -1 : 1)
        let number = NSNumber(value: sum)
        let value = numberFormatter.string(from: number)
        return value
    }
    
    var amountPositive: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        if let currencySymbol = self.currencySymbol, let currencyCode = self.currencyCode  {
            numberFormatter.currencySymbol = currencySymbol
            numberFormatter.currencyCode = currencyCode
            numberFormatter.numberStyle = .currency
        } else {
            numberFormatter.numberStyle = .decimal
        }
        
        let number = NSNumber(value: self.transaction.amount)
        let value = numberFormatter.string(from: number)
        return value
    }
    
    var credit: Bool {
        guard let categoryTypeId = self.transaction.category?.typeId else {
            return false
        }
        guard let categoryType = CategoryType(rawValue: categoryTypeId) else {
            return false
        }
        return  categoryType == .credit
    }
    
    func set(date: String) {
        let dateFormetter = DateFormatter()
//        dateFormetter.dateStyle = .short
//        dateFormetter.timeStyle = .short
        guard let value = dateFormetter.date(from: date) else { return }
        
        set(date: value)
    }
    
    func set(date: Date) {
        dataManager.object(transaction, setValue: date, forKey: "date")
    }
    
    func set(account: Account) {
        dataManager.object(transaction, setValue: account, forKey: "account")
    }
    
    func set(account: String?) {
        guard let title = account else {
            return
        }
        
        guard let account = dataManager.findObject(ofType: Account.self, byValue: title, ofKey: "title") else {
            return
        }
        set(account: account)
    }
    
    func set(category: Category) {
        dataManager.object(transaction, setValue: category, forKey: "category")
    }
    
    func set(amount: String?) {
        guard let amount = amount, !amount.isEmpty else {
            return
        }
        
        let numberFormatter = NumberFormatter()
        
        if let currencySymbol = self.currencySymbol, let currencyCode = self.currencyCode {
            if amount.hasPrefix(currencySymbol) || amount.hasSuffix(currencySymbol) {
                numberFormatter.currencyCode = currencyCode
                numberFormatter.currencySymbol = currencySymbol
                numberFormatter.numberStyle = .currency
            }
        }
        
        guard let nummber = numberFormatter.number(from: amount) else {
            fatalError("Can't get amount from string")
        }
        
        set(amount: nummber.floatValue)
    }
    
    func set(amount: Float) {
        dataManager.object(transaction, setValue: amount, forKey: "amount")
    }
    
    func set(comment: String?) {
        dataManager.object(transaction, setValue: comment, forKey: "comment")
    }
    
    func save() {
        dataManager.save(transaction)
    }
    
    func remove(_ competion: CompletionHandler?) {
        dataManager.remove(transaction) { (error) in
            if let competion = competion {
                competion(error)
            }
        }
    }
}
