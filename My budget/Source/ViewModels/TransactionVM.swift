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
    
    
    override func set(_ value: Any?, forKey key: String) {
        
        let key = key.lowercased()
        
        var rawValue = value
        
        if key == "date", let value = value as? String {
            
            guard let date = dateFormatter.date(from: value) else {
                return
            }
            
            rawValue = date
            
            
        } else if key == "amount" {
            
            var amount: Float = 0
            
            if let value = value as? String {
                
                guard let nummber = decimalFormatter.number(from: value) else {
                    return
                }
                
                amount = nummber.floatValue
                
            } else if let value = value as? Float {
                
                amount = value
                
            } else { return }
    
            rawValue = fabsf(amount) * (categoryType == .credit ? -1 : 1)
        }
        
        super.set(rawValue, forKey: key)
    }
        
    override func save() {
        
        if self.object.amount == 0 {
            return
        }
        
        super.save()
        
        isNew = false
        NotificationCenter.default.post(name: .transaction, object: nil)
    }
    
    deinit {
        if self.isNew {
            dataManager.context?.delete(object)
        }
    }
}
