//
//  AccountObject.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

enum AccountKind: Int, CaseIterable {
    case cash = 0, bankCard, bankAccount, other
}

@objcMembers
final class AccountObject: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var kind: Int = AccountKind.other.rawValue
    dynamic var currencyCode: String? = Locale.current.currencyCode
    let transactions = LinkingObjects(fromType: TransactionObject.self, property: "account")
    
    override class func primaryKey() -> String? { "id" }
}
