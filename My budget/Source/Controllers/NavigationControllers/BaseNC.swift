//
//  BaseNavigationVC.swift
//  My budget
//
//  Created by Николай Маторин on 16.03.2018.
//  Copyright © 2018 Николай Маторин. All rights reserved.
//

import UIKit

class BaseNC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        navigationBar.barTintColor = UIColor.clear
        navigationBar.isTranslucent = true
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        //let colors = [#colorLiteral(red: 0.1215686275, green: 0.1568627451, blue: 0.1764705882, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.03137254902, blue: 0.03529411765, alpha: 1)]
        //navigationBar.setGradientBackground(colors: colors)
        
        dropShadow()
        
    }
    
    func dropShadow() {
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationBar.layer.shadowRadius = 4
        navigationBar.layer.shadowOpacity = 1
        navigationBar.layer.masksToBounds = false
        navigationBar.layer.shadowPath = UIBezierPath(rect: navigationBar.bounds).cgPath
    }
}
