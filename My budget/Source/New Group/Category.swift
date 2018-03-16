//
//  Category.swift
//  My budget
//
//  Created by Николай Маторин on 14.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class Category: Entity {
    let categoryId: String?
    let name: String
    let type: TypeCategory
    weak var parent: Category?
    
    init(categoryId: String?, name: String, type: TypeCategory, parent: Category?) {
        self.categoryId = categoryId
        self.name = name
        self.type = type
        self.parent = parent
    }
}

extension Category {
    enum TypeCategory: Int {
        case income = 1
        case expense = 2
    }
}
