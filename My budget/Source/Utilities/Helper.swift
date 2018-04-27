//
//  Helper.swift
//  My budget
//
//  Created by Николай Маторин on 30.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

final class Helper {
    
    enum FormatterType {
        case date
        case decimal
        case currency
    }
    
    public static let shared = Helper()
    
    private init() {
        
    }
    
    func createFormatter(for type: FormatterType) -> Formatter {
        
        switch type {
        case .date:
             return createDateFormatter()
        case .decimal:
            return createDecimalFormatter()
        case .currency:
            return createCurrencyFormatter()
        }
        
    }
    
    fileprivate func createCurrencyFormatter() -> Formatter {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        guard let currencyCode = UserSettings.defaults.сurrencyCode else {
            return formatter
        }
        
        let local = NSLocale(localeIdentifier: currencyCode)
        
        guard let currencySymbol = local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode) else {
            return formatter
        }
        
        formatter.currencySymbol = currencySymbol
        formatter.currencyCode = currencyCode
        formatter.numberStyle = .currency
        
        return formatter
    }
    
    fileprivate func createDateFormatter() -> Formatter {
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        return formatter
    }
    
    fileprivate func createDecimalFormatter() -> Formatter {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    

    
//    func getCurrencySymbol(forCurrencyCode currencyCode: String) -> String? {
//        let local = NSLocale(localeIdentifier: currencyCode)
//        return local.displayName(forKey: NSLocale.Key.currencySymbol, value: currencyCode)
//    }
//
//    func getCurrencies() -> [String] {
//        return Locale.commonISOCurrencyCodes.sorted(by: {Locale.current.localizedString(forCurrencyCode: $0) ?? ""  < Locale.current.localizedString(forCurrencyCode: $1) ?? "" })
//    }
//
//    func getLocal(forCurrencyCode currencyCode: String) -> Locale {
//        let identifier = Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: currencyCode])
//        return Locale(identifier: identifier)
//    }
//
//    func formatCurrency(_ number: Double, currencyCode: String) -> String? {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.currencyCode = currencyCode
//        if let currencySymbol = getCurrencySymbol(forCurrencyCode: currencyCode) {
//             formatter.currencySymbol = currencySymbol
//        }
//        let formattedString = formatter.string(from: NSNumber(value: number))
//        return formattedString
//    }
}
