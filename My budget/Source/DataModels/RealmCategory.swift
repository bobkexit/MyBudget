//
//  RealmCategory.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory: Object, RealmEntity {
    typealias EntityType = Category
    
    @objc dynamic var categoryID = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var typeId = 0
    @objc dynamic var parent: RealmCategory?
       
    override static func primaryKey() -> String? {
        return "categoryID"
    }
    
    convenience required init(entity: EntityType) {
        self.init()
        
        self.name = entity.name
        self.typeId = entity.type.rawValue
        
        if let categoryId = entity.categoryId {
            self.categoryID = categoryId
        }
    }

    var entity: Category {
        guard let type = Category.TypeCategory(rawValue: typeId) else {
            fatalError("Type category is not defined")
        }
    
        return Category(categoryId: categoryID, name: name, type: type, parent: self.parent?.entity)
    }
    
}


