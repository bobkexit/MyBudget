//
//  AppCoordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class AppCoordinator: BaseCoordinator {
    
    private var window: UIWindow
    
    private let persistentContainer: NSPersistentContainer
    
    private let realm: Realm
    
    private lazy var migration = RealmMigration(viewContext: persistentContainer.viewContext, realm: realm)
    
    private lazy var rootViewController: UITabBarController = UITabBarController()
    
    init(window: UIWindow, realm: Realm, persistentContainer: NSPersistentContainer) {
        self.window = window
        self.persistentContainer = persistentContainer
        self.realm = realm
    }
    
    override func start() {
        migration.isCompleted ? showMainScene() : showLoadingScene()
        window.makeKeyAndVisible()
    }
            
    private func showLoadingScene() {
        let viewController = LoadingViewController()
        
        let presenter = LoadingPresenter(migration: migration, view: viewController) { [unowned self] in
            self.showMainScene()
        }
        migration.delegate = presenter
        viewController.presenter = presenter
        
        window.rootViewController = viewController
    }
    
    private func showMainScene() {
        configureMainScene()
        window.rootViewController = rootViewController
    }
    
    private func configureMainScene() {
        var viewControllers: [UINavigationController] = []
        
        let transactionsCoordinator = TransactionsCoordinator()
        viewControllers.append(transactionsCoordinator.navigationConttroller)
    
        let reportsCoordinator = ReportsCoordinator()
        viewControllers.append(reportsCoordinator.navigationConttroller)
        
        let settingsCoordinator = SettingsCoordinator()
        viewControllers.append(settingsCoordinator.navigationConttroller)
      
        rootViewController.setViewControllers(viewControllers, animated: true)
        
        add(transactionsCoordinator, reportsCoordinator, settingsCoordinator)
    }
}
