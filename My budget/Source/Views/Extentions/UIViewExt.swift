//
//  UIViewExt.swift
//  My budget
//
//  Created by Николай Маторин on 24.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide: String, EnumCollection {
        case left, right, top, bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: UIColor, andThickness thickness: CGFloat) {
        
        removeBorder(fromSide: side)
        
        let border = CALayer()
        border.name = side.rawValue
        border.masksToBounds = true
        border.backgroundColor = color.cgColor
        
        switch side {
        case .left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.size.height)
        case .right: border.frame = CGRect(x: frame.size.width - thickness, y: 0, width: thickness, height: self.frame.size.height)
        case .top: border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: thickness)
        case .bottom: border.frame = CGRect(x: 0, y: frame.size.height - thickness, width: frame.size.width, height: thickness)
        }
        layer.addSublayer(border)
    }
    
    func removeBorder(fromSide side: ViewSide) {
        guard let layer = layer.sublayers?.first(where: {$0.name == side.rawValue}) else {
            return
        }
        layer.removeFromSuperlayer()
    }
    
    func dropShadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat, scale: Bool = true) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        //layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }
    
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer(frame: self.frame, colors: colors)
        
        if let prevGradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer}) {
            self.layer.replaceSublayer(prevGradientLayer, with: gradientLayer)
        } else {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

