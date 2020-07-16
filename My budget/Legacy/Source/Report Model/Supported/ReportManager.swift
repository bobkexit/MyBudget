//
//  ReportFactory.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData

final class ReportManager {
    
    public static let shared = ReportManager()
    
    private let context: NSManagedObjectContext
    
    private init() {
        
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            fatalError("can't find AppDelegate")
        }
        
        self.context = appDelegate.persistentContainer.viewContext
    }
    
    func getAvailableReports() -> [Report] {
        
        var reports = [Report]()
        
        reports.append(ExpensesReport(entityName: "Transaction", context: self.context))
        reports.append(BalanceReport(entityName: "Account", context: self.context))
        
        return reports
    }
    
    func segueIdentifier(forReport report: Report) -> String? {
    
        switch report {
        case is ExpensesReport:
            return Constants.Segues.toExpensesReport
        case is BalanceReport:
            return Constants.Segues.toBalanceReport
        default:
            return nil
        }
    }
}

