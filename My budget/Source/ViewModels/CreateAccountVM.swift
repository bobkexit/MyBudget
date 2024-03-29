//
//  CreateAccountVM.swift
//  My budget
//
//  Created by Николай Маторин on 28.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class CreateAccountVM: AccountVM {
    
    private(set) var balance: Float?
    private(set) var hasBeenSaved: Bool = false
    
    override func set(_ value: Any?, forKey key: String) {
        
        if key.lowercased() == "balance" {
            
            switch value {
            case let value as String:
                guard let value = decimalFormatter.number(from: value) else {
                    return
                }
                self.balance = value.floatValue
            case let value as Float where value > 0:
                self.balance = value
            default:
                return
            }
    
        } else {
            super.set(value, forKey: key)
        }
    }
    
    override func save() {
        super.save()
        self.hasBeenSaved = true
        initBalance()
    }
    
    private func initBalance() {
        
        guard let amount = self.balance, amount > 0 else {
            return
        }
        
        guard let category =  UserSettings.defaults.initialBalance else {
            return
        }
        
        let transactionManager = BaseDataManager<Transaction>()
        guard let transaction = transactionManager.create() else { return }
        
        let transactionVM = ViewModelFactory.shared.create(object: transaction, dataManager: transactionManager)
        
        transactionVM.set(self.object, forKey: "account")
        transactionVM.set(category, forKey: "category")
        transactionVM.set(amount, forKey: "amount")
        
        transactionVM.save()
        
        NotificationCenter.default.post(name: .transaction, object: nil)
    }
    
    deinit {
        if !hasBeenSaved {
            dataManager.context?.delete(object)
        }
    }
}
