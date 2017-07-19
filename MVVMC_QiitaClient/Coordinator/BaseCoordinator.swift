//
//  BaseCoordinator.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator, DependencyCoordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func start() { fatalError("Required Override method") }
    
    func addDependency(coordinator: Coordinator) {
        if childCoordinators.contains(where: { $0 === coordinator }) {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(coordinator: Coordinator?) {
        guard let coordinator = coordinator else {
            return
        }
        guard let index = childCoordinators.index(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.remove(at: index)
    }
    
}
