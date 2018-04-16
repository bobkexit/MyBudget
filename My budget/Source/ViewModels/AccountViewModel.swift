//
//  AccountViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

struct AccountViewModel {
   
    typealias Entity = Account
    typealias AccountType = BaseViewModel.AccountType
    typealias CompletionHandler = (_ error: Error?) -> ()
    
    private let account: Entity
    private let dataManager = DataManager.shared
    
    
    init(withAccount account: Entity) {
        self.account = account
    }
    
    var id: String {
        return self.account.id
    }
    
    var title: String {
        return self.account.title
    }
    
    var accountType: AccountType {
        let typeId = self.account.typeId
        
        if let value = AccountType(rawValue: typeId) {
            return value
        } else {
            let accountTypes = Array(AccountType.cases())
            guard let value = accountTypes.first else { fatalError("can't find any account types") }
            return value
        }
    }
    
//    var currencyCode: String? {
//        //return self.account.currencyCode
//        return nil
//    }
//
//    var currencySymbol: String? {
//        guard let currencyCode = self.account.currencyCode else {
//            return nil
//        }
//        let local = NSLocale(localeIdentifier: currencyCode)
//        let symbol = local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode)
//        return symbol
//    }
    
    func set(title: String) {
        dataManager.object(account, setValue: title, forKey: "title")
        NotificationCenter.default.post(name: .accountHasBeenUpdated, object: nil)
    }
    
    func set(accountType: AccountType) {
        dataManager.object(account, setValue: accountType.rawValue, forKey: "typeId")
        NotificationCenter.default.post(name: .accountHasBeenUpdated, object: nil)
    }
    
    func set(balance: String) {
        fatalError("Not implemented")
    }
    
    func save() {
        dataManager.save(account)
        NotificationCenter.default.post(name: .accountHasBeenCreated, object: nil)
    }
    
    func remove(_ competion: CompletionHandler?) {
        dataManager.remove(account) { (error) in
            if error == nil {
                 NotificationCenter.default.post(name: .accountHasBeenDeleted, object: nil)
            }
            
            if let competion = competion {
                competion(error)
            }
        }
    }
}
