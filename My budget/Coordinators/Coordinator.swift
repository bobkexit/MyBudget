//
//  Coordinator.swift
//  My budget
//
//  Created by Николай Маторин on 16.07.2020.
//  Copyright © 2020 Николай Маторин. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {
    private var childCoordinators: [Coordinator] = []
    
    func start() { }
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
}
