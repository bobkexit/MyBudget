//
//  RealmCategory.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object {
    
    @objc dynamic var categoryId = UUID().uuidString
    @objc dynamic var name = ""
    @objc private dynamic var categoryTypeId = 0
    
    override static func primaryKey() -> String? {
        return "categoryId"
    }
    
//    @objc dynamic var parentCategory: RealmCategory?
//    let subCategories = LinkingObjects(fromType: RealmCategory.self, property: "parentCategory")
    
    var categoryType: CategoryType {
        get {
            return CategoryType(rawValue: categoryTypeId)!
        }
        set {
            categoryTypeId = newValue.rawValue
        }
    }
    
    convenience init(name: String, categoryType: CategoryType ) {
        self.init()
        self.name = name
        self.categoryType = categoryType
    }
}

extension RealmCategory {
    enum CategoryType: Int {
        case income = 1
        case expense = 2
    }
}



