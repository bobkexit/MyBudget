//
//  ReportFactory.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

final class ReportFactory {
    
    public static let shared = ReportFactory()
    
    private let context: NSManagedObjectContext
    
    private init() {
        
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            fatalError("can't find AppDelegate")
        }
        
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func create(report: Reports) -> Report? {
        return nil
    }
    
    func getAvailableReports() -> [Report] {
        
        var reports = [Report]()
        
        reports.append(ExpensesReport(entityName: "Transaction", context: self.context))
        
        return reports
    }
    
    func segueIdentifier(forReport report: Report) -> String? {
        
        if report is ExpensesReport {
            return Constants.Segues.toExpensesReport
        }
        
        return nil
    }
}

