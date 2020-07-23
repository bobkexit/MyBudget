//
//  String+Ext.swift
//  My budget
//
//  Created by Николай Маторин on 22.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func localizeCapitalizingFirstLetter(comment: String = "") -> String {
        return self.localized(comment: comment).capitalizingFirstLetter()
    }
    
    func combine(with otherString: String, localize: Bool = true, capitalizeFirstLetter: Bool = true) -> String {
        var firstString = self
        var secondString = otherString
        
        if localize {
            firstString = firstString.localized()
            secondString = secondString.localized()
        }
        
        if capitalizeFirstLetter {
            firstString = firstString.capitalizingFirstLetter()
        }
        
        
        return firstString + " " + secondString
    }
}
