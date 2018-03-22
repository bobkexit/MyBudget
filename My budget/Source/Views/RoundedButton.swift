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
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var topRight: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var bottomRight: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var topLeft: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var bottomLeft: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customizeView()
    }
    
    func customizeView() {
        
        let corners = getCorners()
        roundCorners(corners, radius: cornerRadius)
        self.clipsToBounds = true
    }
    
    func getCorners() -> UIRectCorner {
        
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

    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
}
