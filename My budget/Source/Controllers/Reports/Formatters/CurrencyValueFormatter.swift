//
//  CurrencyValueFormatter.swift
//  My budget
//
//  Created by Николай Маторин on 26.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation
import Charts

class CurrencyValueFormatter: IValueFormatter {
    
    private let formatter = NumberFormatter()
    
    init() {
        setupFormatter()
    }
    
    func setupFormatter() {
        
        guard let currencyCode = UserSettings.defaults.сurrencyCode else {
            return
        }
        
        let local = NSLocale(localeIdentifier: currencyCode)
        
        guard let currencySymbol = local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode) else {
            return
        }
        
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.currencySymbol = currencySymbol
        formatter.currencyCode = currencyCode
        formatter.numberStyle = .currency
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        let rawValue = entry.data as? Double
        
        let number = NSNumber(value: rawValue ?? value)
        
        return formatter.string(from: number) ?? ""
    }
}
