//
//  CategoryObject.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

enum CategoryKind: Int, CaseIterable {
    case expense = 0, income
}

@objcMembers
final class CategoryObject: Object {
    dynamic var id: String = UUID().uuidString
    dynamic var name: String = ""
    dynamic var kind: Int = CategoryKind.expense.rawValue
    let transactions = LinkingObjects(fromType: TransactionObject.self, property: "category")
    
    override class func primaryKey() -> String? { "id" }
}
