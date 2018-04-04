//
//  GradientView.swift
//  My budget
//
//  Created by Николай Маторин on 27.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable
    var topColor: UIColor = Constants.Colors.gradientBackground.first! {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var bottomColor: UIColor = Constants.Colors.gradientBackground.last! {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.applyGradient(colors: [topColor, bottomColor])
    }
}
