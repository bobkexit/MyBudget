//
//  TransactionObject.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
final class TransactionObject: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var date: Date = Date()
    dynamic var account: AccountObject?
    dynamic var category: CategoryObject?
    dynamic var ammount: Float = 0.0
    dynamic var comment: String = ""
    
    override class func primaryKey() -> String? { "id" }
}
