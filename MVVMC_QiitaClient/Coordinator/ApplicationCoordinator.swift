//
//  ApplicationCoordinator.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

class ApplicationCoordinator: BaseCoordinator {
    
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        runMainTabbarFlow()
    }
    
    private func runAuthFlow() {
        let coordinator = coordinatorFactory.generateAuthCoordinator(router: router)
        addDependency(coordinator: coordinator)
        coordinator.start()
    }
    
    private func runMainTabbarFlow() {
        let (presentable, coordinator) = coordinatorFactory.generateTabbarCoordinator()
        addDependency(coordinator: coordinator)
        router.setRoot(presentable: presentable, hideBar: true)
        coordinator.start()
    }
    
}
