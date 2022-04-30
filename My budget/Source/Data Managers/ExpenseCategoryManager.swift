//
//  ExpenseCategoryManager.swift
//  My budget
//
//  Created by Николай Маторин on 20.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

class ExpenseCategoryManager: BaseDataManager<Category> {
    
    private let categoryType = CategoryType.credit
    
    override func getObjects() -> [Category] {
        
        var result = [Category]()
        
        let typeId = Int16(categoryType.rawValue)
        
        let query = NSFetchRequest<Category>(entityName: "Category")
        query.predicate = NSPredicate(format: "typeId == \(typeId)")
        
        do {
            result = try context?.fetch(query) ?? []
        } catch  {
            print(error as Any)
        }
        
        return result
    }
    
    override func create() -> Category? {
        guard let object = super.create() else { return nil }
        object.typeId = Int16(categoryType.rawValue)
        return object
    }
}
