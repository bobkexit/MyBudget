//
//  RealmAccount.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAccount: Object {
    
    @objc dynamic var accountId = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var accountTypeId = 0
    @objc dynamic var currencyCode: String? = Locale.current.currencyCode
    
    var accountType: RealmAccount.AccountType? {
        get {
            return AccountType(rawValue: accountTypeId)
        }
        set {
            accountTypeId = newValue?.rawValue ?? 0
        }
    }
    
    override static func primaryKey() -> String? {
        return "accountId"
    }
    
    convenience init(name: String, accountType: AccountType, currencyCode: String) {
        self.init()
        self.name = name
        self.accountTypeId = accountType.rawValue
        self.currencyCode = currencyCode
    }
    
    convenience init(name: String, accountTypeId: Int, currencyCode: String, accountId: String?) {
        self.init()
        self.name = name
        self.accountTypeId = accountTypeId
        self.currencyCode = currencyCode
        
        if let accountId = accountId {
            self.accountId = accountId
        }
    }
}

extension RealmAccount {
    enum AccountType: Int, EnumCollection, CustomStringConvertible {
        case paymentCard = 1
        case cash = 2
        case web = 3
        case bankAccont = 4
        
        var description: String {
            switch self {
            case .paymentCard:
                return "payment card"
            case .cash:
                return "cash"
            case .web:
                return "web"
            case .bankAccont:
                return "bank account"
            }
        }
        
        var image: UIImage {
            switch self {
            case .paymentCard:
                return Constants.Images.creditCard
            case .cash:
                return Constants.Images.wallet
            case .web:
                return Constants.Images.web
            case .bankAccont:
                return Constants.Images.safe
            }
        }
    }
}
