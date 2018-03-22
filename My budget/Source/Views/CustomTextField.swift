//
//  CustomTextField.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextField: UITextField {
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customizeView()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        customizeView()
//    }
    
    func customizeView() {
        
        let borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        
        backgroundColor = #colorLiteral(red: 0.4823529412, green: 0.4941176471, blue: 0.5568627451, alpha: 0.82)
     
        borderStyle = .none
        self.addBorder(toSide: .top, withColor: borderColor, andThickness: 1)
        self.addBorder(toSide: .bottom, withColor: borderColor, andThickness: 1)
        self.layer.masksToBounds = true
    }
}

extension UIView {

    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)

    enum ViewSide {
        case left, right, top, bottom
    }

    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {

        let border = CALayer()
        border.backgroundColor = color.cgColor

        switch side {
        case .left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.size.height)
        case .right: border.frame = CGRect(x: frame.size.width - thickness, y: 0, width: thickness, height: self.frame.size.height)
        case .top: border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
        case .bottom: border.frame = CGRect(x: 0, y: frame.size.height - thickness, width: frame.size.width, height: thickness)
        }
        layer.addSublayer(border)
    }
}

