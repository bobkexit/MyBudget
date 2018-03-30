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
    
    func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }
}
