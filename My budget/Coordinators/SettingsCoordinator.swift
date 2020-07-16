//
//  SettingsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsCoordinator: BaseCoordinator {
    
    private(set) lazy var navigationConttroller: UINavigationController = UINavigationController()
    
    override func start() {
        configureNavigationConttroller()
        showSettings()
    }
    
    private func configureNavigationConttroller() {
        
    }
    
    private func showSettings() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .red
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
