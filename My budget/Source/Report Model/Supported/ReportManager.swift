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
    
    static let shared = ReportManager()

    private init() { }
    
    func getAvailableReports() -> [Report] {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return [] }
        
        let context = appDelegate.persistentContainer.viewContext
        
        return [
            ExpensesReport(entityName: "Transaction", context: context),
            BalanceReport(entityName: "Account", context: context)
        ]
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

