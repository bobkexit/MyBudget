//
//  RoundedView.swift
//  My budget
//
//  Created by Николай Маторин on 22.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView {

    @IBInspectable
    var cornerRadius: CGFloat = 8 {
        didSet{
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var dropShadow: Bool = false
    
    @IBInspectable
    var shadowColor: UIColor = .black
    
    @IBInspectable
    var shadowOpacity: Float = 1
    
    @IBInspectable
    var shadowRadius: CGFloat = 1
    
    @IBInspectable
    var shadowScale: Bool = true
    
    @IBInspectable
    var shadowWidth: Int = 0
    
    @IBInspectable
    var shadowHeight: Int = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        if dropShadow {
            let shadowOffest = CGSize(width: shadowWidth, height: shadowHeight)
            self.dropShadow(color: shadowColor, opacity: shadowOpacity, offset: shadowOffest, radius: shadowRadius, scale: shadowScale)
        }
    }
}
