//
//  BaseVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = tabBarController?.tabBar.selectedItem?.title
        setupView()
    }
    
    func setupView() {
        let colors = [#colorLiteral(red: 0.1215686275, green: 0.1568627451, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.03137254902, blue: 0.03529411765, alpha: 1)]
        
        let gradientLayer = CAGradientLayer(frame: self.view.bounds, colors: colors)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
