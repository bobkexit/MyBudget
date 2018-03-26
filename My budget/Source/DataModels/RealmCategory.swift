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
    @objc dynamic var categoryTypeId = 0
    
    override static func primaryKey() -> String? {
        return "categoryId"
    }
    
//    @objc dynamic var parentCategory: RealmCategory?
//    let subCategories = LinkingObjects(fromType: RealmCategory.self, property: "parentCategory")
    
    convenience init(name: String, categoryType: CategoryType, categoryId: String? = nil ) {
        self.init()
        self.name = name
        self.categoryTypeId = categoryType.rawValue
        
        if let categoryId = categoryId {
            self.categoryId = categoryId
        }
    }
}



