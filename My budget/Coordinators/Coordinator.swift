//
//  Coordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: NSObject, Coordinator {
    private var childCoordinators: [Coordinator] = []
    
    var onComplete: ((BaseCoordinator) -> Void)?
    
    func start() { }
}

extension BaseCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onComplete?(self)
    }
}

extension BaseCoordinator {
    func add(_ child: Coordinator) {
        childCoordinators.append(child)
    }
    
    func remove(_ child: Coordinator) {
        guard let index = childCoordinators.firstIndex(where: { $0 === child }) else { return }
        childCoordinators.remove(at: index)
    }
    
    func add(_ children: Coordinator...) {
        for child in children {
            add(child)
            child.start()
        }
    }
    
    public func makeNavigationController() -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.presentationController?.delegate = self
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let textAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.babyPowder]
        appearance.largeTitleTextAttributes = textAttributes
        appearance.titleTextAttributes = textAttributes
        
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = .orangePeel
        
        return navigationController
    }
}

