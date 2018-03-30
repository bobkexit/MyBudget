//
//  UITextFieldExt.swift
//  My budget
//
//  Created by Николай Маторин on 30.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

extension UITextField {
    @IBInspectable var placeholderTextColor: UIColor? {
        set {
            guard let color = newValue else { return }
            
            let placeholderText = self.placeholder ?? ""
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor: color.withAlphaComponent(self.alpha)])
        }
        get{
            return self.placeholderTextColor
        }
    }
}
