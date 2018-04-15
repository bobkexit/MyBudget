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
        guard let value = AccountType(rawValue: typeId) else {
            return .none
        }
        return value
    }
    
    var currencyCode: String? {
        return self.account.currencyCode
    }
    
    var currencySymbol: String? {
        guard let currencyCode = self.account.currencyCode else {
            return nil
        }
        let local = NSLocale(localeIdentifier: currencyCode)
        let symbol = local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode)
        return symbol
    }
    
    func set(title: String) {
        dataManager.object(account, setValue: title, forKey: "title")
    }
    
    func set(accountType: AccountType) {
        dataManager.object(account, setValue: accountType.rawValue, forKey: "typeId")
    }
    
    func set(currencyCode: String) {
        dataManager.object(account, setValue: currencyCode, forKey: "currencyCode")
    }
    
    func save() {
        dataManager.save(account)
    }
    
    func remove(_ competion: CompletionHandler?) {
        dataManager.remove(account) { (error) in
            if let competion = competion {
                competion(error)
            }
        }
    }
}
