//
//  CustomTextField.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

@IBDesignable
class BorderedTextField: UITextField {
    
    @IBInspectable
    var borderTopSide: Bool = false
    
    @IBInspectable
    var borderLeftSide: Bool = false
    
    @IBInspectable
    var borderBottomSide: Bool = false
    
    @IBInspectable
    var borderRightSide: Bool = false
        
    @IBInspectable
    var borderColor: UIColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
    
    @IBInspectable
    var borderThickness: CGFloat = 1
    
    @IBInspectable
    var paddingTop: CGFloat = 0
   
    @IBInspectable
    var paddingLeft: CGFloat = 0
    
    @IBInspectable
    var paddingBottom: CGFloat = 0
    
    @IBInspectable
    var paddingRight: CGFloat = 0 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createBorder()
    }
    
    fileprivate func createBorder() {
        borderStyle = .none
        layer.masksToBounds = true
        
        if borderTopSide {
            self.addBorder(toSide: .top, withColor: borderColor, andThickness: borderThickness)
        } else {
            self.removeBorder(fromSide: .top)
        }
        
        if borderBottomSide {
            self.addBorder(toSide: .bottom, withColor: borderColor, andThickness: borderThickness)
        } else {
            self.removeBorder(fromSide: .bottom)
        }
        
        if borderRightSide {
            self.addBorder(toSide: .right, withColor: borderColor, andThickness: borderThickness)
        } else {
            self.removeBorder(fromSide: .right)
        }
        
        if borderLeftSide {
            self.addBorder(toSide: .left, withColor: borderColor, andThickness: borderThickness)
        } else {
            self.removeBorder(fromSide: .left)
        }
    }
    
    fileprivate func getTextRect(forBounds bounds: CGRect) -> CGRect {
        let padding = UIEdgeInsets(top: paddingTop, left: paddingLeft, bottom: paddingBottom, right: paddingRight)
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return getTextRect(forBounds:bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return getTextRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return getTextRect(forBounds: bounds)
    }
}


