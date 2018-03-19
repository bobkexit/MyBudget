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
        // Colors
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.clear
        navigationBar.isTranslucent = true
        
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
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
