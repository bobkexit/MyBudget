//
//  AccountContoller.swift
//  My budget
//
//  Created by Nikolay Matorin on 26.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

protocol AccountContollerProtocol: AnyObject {
    var accountName: String? { get  }
    var currencyCode: String? { get  }
    var accountType: AccountKind { get  }
    var accountTypes: [AccountKind] { get }
    var isNewAccount: Bool { get }
    
    func updateAccount(name: String)
    func updateAccount(currencyCode: String?)
    func updateAccount(type: AccountKind)
    func saveAccount()
}

class AccountContoller: AccountContollerProtocol {
    
    var accountName: String? { account.name }
    
    var currencyCode: String? { account.currencyCode }
    
    var accountType: AccountKind { account.kind }
    
    var accountTypes: [AccountKind] { AccountKind.allCases }
    
    var isNewAccount: Bool { return repository.find(AccountObject.self, byID: account.id) == nil }
    
    private var account: AccountDTO
    
    private let repository: Repository
    
    init(repository: Repository, account: AccountDTO) {
        self.account = account
        self.repository = repository
    }
    
    func updateAccount(name: String) {
        account = account.copy(name: name)
    }
    
    func updateAccount(currencyCode: String?) {
        account = account.copy(currencyCode: currencyCode)
    }
    
    func updateAccount(type: AccountKind) {
        account = account.copy(kind: type)
    }
    
    func saveAccount() {
        if let accountObject = repository.find(AccountObject.self, byID: account.id) {
            let account = self.account
            repository.update {
                accountObject.name = account.name
                accountObject.currencyCode = account.currencyCode
                accountObject.kind = account.kind.rawValue
            }
        } else {
            let accountObject = AccountObject()
            accountObject.name = account.name
            accountObject.currencyCode = account.currencyCode
            accountObject.kind = account.kind.rawValue
            
            do {
                try repository.save(accountObject)
                account = AccountDTO(account: accountObject)
            } catch let error {
                print("Failed to create account. Error = \(error)")
            }
        }
    }
}
