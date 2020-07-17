//
//  SettingsCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

class SettingsCoordinator: BaseCoordinator {
    
    let navigationConttroller: UINavigationController
    
    init(navigationConttroller: UINavigationController) {
        self.navigationConttroller = navigationConttroller
        super.init()
    }
    
    override func start() {
        showSettings()
    }
        
    private func showSettings() {
        let viewController = SettingsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Settings", image: .gearShape, tag: 3)
        navigationConttroller.setViewControllers([viewController], animated: true)
    }
}
