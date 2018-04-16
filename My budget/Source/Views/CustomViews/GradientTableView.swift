//
//  GradientTableView.swift
//  My budget
//
//  Created by Николай Маторин on 27.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

@IBDesignable
class GradientTableView: UITableView {

    @IBInspectable
    var topColor: UIColor = Constants.DefaultColors.gradientBackground.first! {
        didSet {
            self.setNeedsLayout()
        }
    }

    @IBInspectable
    var bottomColor: UIColor = Constants.DefaultColors.gradientBackground.last! {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let backgroundView = UIView(frame: self.frame)
        backgroundView.applyGradient(colors: [topColor, bottomColor])
        self.backgroundView = backgroundView
    }

}
