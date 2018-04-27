//
//  TransactionViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class TransactionVM: BaseViewModel<Transaction> {
    
    // MARK: - Properties
    
    var operationType: CategoryType = .credit
    
    var isNew: Bool = false
    
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
    
    var accountID: URL? {
        let account = object.account
        let accountId = account?.objectID.uriRepresentation()
        return accountId
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
    
    var categoryId: URL? {
        let category = object.category
        let categoryId = category?.objectID.uriRepresentation()
        return categoryId
    }
    
    var date: String {
        
        guard let date = object.date else {
            return dateFormatter.string(from: Date())
        }
       
        let value = dateFormatter.string(from: date)
        return value
    }
    
    var comment: String? {
        return self.object.comment
    }
    
    var amount: String? {
        let number = NSNumber(value: self.object.amount)
        let value = decimalFormatter.string(from: number)
        return value
    }
    
    var amountAbs: String? {
        let number = NSNumber(value: fabsf(self.object.amount))
        let value = decimalFormatter.string(from: number)
        return value
    }
    
    var currencyAmount: String? {
        let number = NSNumber(value: self.object.amount)
        let value = currencyFormatter.string(from: number)
        
        return value
    }
    
    var color: UIColor {
        let debitColor = Constants.DefaultColors.green
        let creditColor = Constants.DefaultColors.red
        return (self.object.amount < 0 ? creditColor : debitColor)
    }
    
    // MARK: - Setters
    
    func set(date: String) {
        guard let value = self.dateFormatter.date(from: date) else {
            return
        }
        set(value, forKey: "date")
    }
    
    
    func set(amount: String?) {
        guard let amount = amount, !amount.isEmpty else {
            return
        }
        
        guard let nummber = decimalFormatter.number(from: amount) else {
            return
        }
        
        set(amount: nummber.floatValue)
    }
    
    func set(amount: Float) {
        let value = fabsf(amount) * (categoryType == .credit ? -1 : 1)
        set(value, forKey: "amount")
    }
    
    override func save() {
        super.save()
        isNew = false
    }
    
    deinit {
        if self.isNew {
            dataManager.context.delete(object)
        }
    }
}
