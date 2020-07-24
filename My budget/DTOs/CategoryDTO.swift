//
//  CategoryDTO.swift
//  My budget
//
//  Created by Николай Маторин on 17.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

struct CategoryDTO: Hashable {
    let id: String
    let name: String
    let kind: CategoryKind
    let sortIndex: Int
}

extension CategoryDTO {
    func copy(name: String? = nil, kind: CategoryKind? = nil, sortIndex: Int? = nil) -> CategoryDTO {
        return CategoryDTO(id: id, name: name ?? self.name, kind: kind ?? self.kind, sortIndex: sortIndex ?? self.sortIndex)
    }
    
    init(category: CategoryObject) {
        self.id = category.id
        self.name = category.name
        self.kind = CategoryKind(rawValue: category.kind)!
        self.sortIndex = category.sortIndex
    }
}
