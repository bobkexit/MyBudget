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
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "typeId = %@","\(categoryType.rawValue)")
        
        do {
            result = try context.fetch(request)
        } catch  {
            print(error as Any)
        }
        
        return result
    }
    
    override func create() -> Category {
        
        let object = super.create()
        
        object.typeId = Int16(categoryType.rawValue)
        
        return object
    }
}
