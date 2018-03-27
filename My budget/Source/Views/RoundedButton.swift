//
//  CustomButton.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable
    var cornerRadius: CGFloat = 8 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var topRight: Bool = false
    
    @IBInspectable
    var bottomRight: Bool = false
    
    @IBInspectable
    var topLeft: Bool = false
    
    @IBInspectable
    var bottomLeft: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let corners = getCorners()
        self.roundCorners(corners, radius: cornerRadius)
        self.clipsToBounds = true
    }
    
    fileprivate func getCorners() -> UIRectCorner {
        
        var corners = UIRectCorner.ArrayLiteralElement()
        
        if topLeft {
            corners.insert(.topLeft)
        }
        
        if bottomLeft {
            corners.insert(.bottomLeft)
        }
        
        if topRight {
             corners.insert(.topRight)
        }
        
        if bottomRight {
             corners.insert(.bottomRight)
        }
        
        return corners
    }   
}
