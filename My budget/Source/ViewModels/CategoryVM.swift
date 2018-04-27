//
//  CategoryViewModel.swift
//  My budget
//
//  Created by Николай Маторин on 11.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

class CategoryVM: BaseViewModel<Category> {
    
    // MARK: - Public Properties
    
    var id: String {
        let objectID = object.objectID
        let url = objectID.uriRepresentation()
        return url.absoluteString
    }
    
    var title: String? {
        return object.title
    }
    
    var categoryType: CategoryType  {
        let typeId = Int(self.object.typeId)
        guard let value = CategoryType(rawValue: typeId) else {
            fatalError("Incorrect category typeId")
        }
        return value
    }
    
    
    // MARK: - Setters
    
    func set(categoryType: CategoryType) {
        object.typeId = Int16(categoryType.rawValue)
    }
}
