//
//  QRCodeParser.swift
//  My budget
//
//  Created by Николай Маторин on 13.04.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

// MARK: - Protocol Declaration

protocol QRCodeParserProtocol {
    func parse(code: String,  completion: (_ date: Date?, _ sum: Float?) -> ())
    func parseRaw(code: String, completion: (_ rawDate: String?, _ rawSum: String?) -> ())
}


// MARK: - Class Declaration

class QRCodeParser: QRCodeParserProtocol {
    
    // MARK: - Singleton Declaration
    
    static let shared = QRCodeParser()
    
    private init() { }
    
    // MARK: - QRCodeParserProtocol Methods
    
    func parse(code: String, completion: (Date?, Float?) -> ()) {
        var date: Date?
        var sum: Float?
        
        let components = code.components(separatedBy: "&")

        for component in components {
            if let _ = date, let _ = sum { break }

            let string = component.components(separatedBy: "=").last
            
            if component.hasPrefix("t=") {
                date = parseDate(fromString: string)
            } else if component.hasPrefix("s=") {
                sum = parseSum(fromString: string)
            }
        }
        
        completion(date, sum)
    }
    
    func parseRaw(code: String, completion: (String?, String?) -> ()) {
        var rawDate: String?
        var rawSum: String?
        
        let components = code.components(separatedBy: "&")
        
        for component in components {
            if let _ = rawDate, let _ = rawSum { break }
            
            if component.hasPrefix("t=") {
                rawDate = component
            } else if component.hasPrefix("s=") {
                rawSum = component
            }
        }
        
        completion(rawDate, rawSum)
    }
    
    
    //MARK: - Private Methods
    
    private func parseDate(fromString string: String?) -> Date? {
        guard let string = string else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmm"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        
        if let parsedDate = dateFormatter.date(from: string) {
            return parsedDate
        }
        
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        let parsedDate = dateFormatter.date(from: string)
        
        return parsedDate
    }
    
    private func parseSum(fromString string: String?) -> Float? {
        guard let string = string as NSString? else { return nil }
        return string.floatValue
    }
}
