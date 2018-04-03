//
//  Helper.swift
//  My budget
//
//  Created by Николай Маторин on 30.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

final class Helper {
    public static let shared = Helper()
    
    private init() {
        
    }
    
    func getDateFormatter(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) -> DateFormatter {
        let dateFormatter = DateFormatter()
    
        dateFormatter.locale = Locale.current
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        
        return dateFormatter
    }
    
    func getCurrencySymbol(forCurrencyCode currencyCode: String) -> String? {
        let local = NSLocale(localeIdentifier: currencyCode)
        return local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode)
    }
    
    func getCurrencies() -> [String] {
        return Locale.commonISOCurrencyCodes.sorted(by: {Locale.current.localizedString(forCurrencyCode: $0) ?? ""  < Locale.current.localizedString(forCurrencyCode: $1) ?? "" })
    }
    
    func getLocal(forCurrencyCode currencyCode: String) -> Locale {
        let identifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
        return Locale(identifier: identifier)
    }
    
    func formatCurrency(_ number: Double, currencyCode: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        if let currencySymbol = getCurrencySymbol(forCurrencyCode: currencyCode) {
             formatter.currencySymbol = currencySymbol
        }
        let formattedString = formatter.string(from: NSNumber(value: number))
        return formattedString
    }
}
