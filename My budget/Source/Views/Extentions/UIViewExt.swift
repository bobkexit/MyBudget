//
//  UIViewExt.swift
//  My budget
//
//  Created by Николай Маторин on 24.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

extension UIView {
    func applyGradient(colors: [UIColor]) {
        let gradientLayer = CAGradientLayer(frame: self.frame, colors: colors)
        
        if let prevGradientLayer = self.layer.sublayers?.first(where: { $0 is CAGradientLayer}) {
            self.layer.replaceSublayer(prevGradientLayer, with: gradientLayer)
        } else {
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}

