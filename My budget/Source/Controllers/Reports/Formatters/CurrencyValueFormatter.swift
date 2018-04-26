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
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.currencySymbol = currencySymbol
        currencyFormatter.currencyCode = currencyCode
        currencyFormatter.numberStyle = .currency
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        
        let number = NSNumber(value: value)
        return formatter.string(from: number) ?? ""
    }
}
