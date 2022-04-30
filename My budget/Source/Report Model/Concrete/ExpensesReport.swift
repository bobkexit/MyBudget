//
//  ExpensesReport.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import CoreData

class ExpensesReport: BaseReport {
    
    override var description: String { Localization.monthlyExpensesReport }
    
    override func execute(_ completeion: Report.comletionHandler?) {
        
        var expressionDescriptions = [AnyObject]()
        expressionDescriptions.append(categoryColumn)
        expressionDescriptions.append(totalAmountColumn)
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        // This is the column we are grouping by. Notice this is the only non aggregate column.
        request.propertiesToGroupBy = ["category.title"]
        // Specify we want dictionaries to be returned
        request.propertiesToFetch = expressionDescriptions
        request.resultType = .dictionaryResultType
        request.predicate = NSPredicate(format: "category.typeId == \(CategoryType.credit.rawValue)")
        
        
        if let pastDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()), let currentPredicate = request.predicate {
            
            let startDate = Calendar.current.startOfDay(for: pastDate)
            let additionalPredicate =  NSPredicate(format: "date >= %@", startDate as NSDate)
            let nextPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [currentPredicate, additionalPredicate])
            
            request.predicate = nextPredicate
        }
       
        
        request.sortDescriptors = [NSSortDescriptor(key: "amount", ascending: false),
                                   NSSortDescriptor(key: "category", ascending: true)]
        request.fetchLimit = Constants.Reports.countCategoriesToShow 

        
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
    
    private var categoryColumn: NSExpressionDescription {
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
    
    private var totalAmountColumn: NSExpressionDescription {
      
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
