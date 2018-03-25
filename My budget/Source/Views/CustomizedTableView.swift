//
//  CustomizedTableView.swift
//  My budget
//
//  Created by Николай Маторин on 25.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

@IBDesignable
class CustomizedTableView: UITableView {

    @IBInspectable
    var gradientBackground: Bool = true
    
    @IBInspectable
    var topGradientColor: UIColor = #colorLiteral(red: 0.1215686275, green: 0.1568627451, blue: 0.1764705882, alpha: 1)
    
    @IBInspectable
    var bottomGradinetColor: UIColor = #colorLiteral(red: 0.03137254902, green: 0.03137254902, blue: 0.03529411765, alpha: 1)
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customizeView()
    }

    fileprivate func customizeView() {
        if gradientBackground {
            let gradientLayer = CAGradientLayer(frame: bounds, colors: [topGradientColor, bottomGradinetColor])
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
