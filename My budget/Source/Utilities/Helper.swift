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
    
    func trancate(Phrase phrase: String) -> String {
            
        var trancatedWords = [String]()
        
        let words = phrase.components(separatedBy: " ")
        words.forEach {
            let length = ($0.count > 10 ? 3 : $0.count)
            let trancatedWord = $0.trunc(length: length, trailing: ".")
            trancatedWords.append(trancatedWord)
        }
        
        let result = trancatedWords.joined(separator: " ")
        
        return result
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
}
