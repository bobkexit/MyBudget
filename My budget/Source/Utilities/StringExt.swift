//
//  StringExt.swift
//  My budget
//
//  Created by Николай Маторин on 05.05.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import Foundation

extension String {
    /*
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     - Parameter length: Desired maximum lengths of a string
     - Parameter trailing: A 'String' that will be appended after the truncation.
     
     - Returns: 'String' object.
     */
    func trunc(length: Int, trailing: String = "…") -> String {
        return (self.count > length) ? self.prefix(length) + trailing : self
    }
    
    var capitalizingFirstLetter: String {
        prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter
    }
}
