//
//  ExpensesReport.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

class ExpensesReport: Report {
    
    let context: NSManagedObjectContext
    
    let entityName: String
    
    var description: String {
        return "Expenses"
    }
    
    required init(entityName: String, context: NSManagedObjectContext) {
        self.entityName = entityName
        self.context = context
    }
    
    func execute(_ completeion: Report.comletionHandler?) {
        
        var expressionDescriptions = [AnyObject]()
        expressionDescriptions.append(categoryColumn)
        expressionDescriptions.append(totalAmountColumn)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        // This is the column we are grouping by. Notice this is the only non aggregate column.
        request.propertiesToGroupBy = ["category.title"]
        // Specify we want dictionaries to be returned
        request.resultType = .dictionaryResultType
        request.predicate = NSPredicate(format: "category.typeId == \(CategoryType.credit.rawValue)")
        request.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        
        request.propertiesToFetch = expressionDescriptions
        
        var results:[[String:AnyObject]]?
        
        do {
            results = try context.fetch(request) as? [[String:AnyObject]]
        } catch  {
            print(error as Any)
        }
        
        if let completeion = completeion {
            completeion(results as [AnyObject]?)
        }
    }
    
    fileprivate var categoryColumn: NSExpressionDescription {
        let expressionDescription = NSExpressionDescription()
        // Name the column
        expressionDescription.name = "category"
        // Use an expression to specify what aggregate action we want to take and
        // on which column. In this case sum on the sold column
        expressionDescription.expression = NSExpression(format: "category.title")
        // Specify the return type we expect
        expressionDescription.expressionResultType = .stringAttributeType
        
        return expressionDescription
    }
    
    fileprivate var totalAmountColumn: NSExpressionDescription {
      
        let expressionDescription = NSExpressionDescription()
        // Name the column
        expressionDescription.name = "totalAmount"
        // Use an expression to specify what aggregate action we want to take and
        // on which column. In this case sum on the sold column
        expressionDescription.expression = NSExpression(format: "@sum.amount")
        // Specify the return type we expect
        expressionDescription.expressionResultType = .doubleAttributeType
        
        return expressionDescription
    }
}
