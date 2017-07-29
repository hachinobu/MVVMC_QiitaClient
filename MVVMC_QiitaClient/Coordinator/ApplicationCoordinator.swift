//
//  ApplicationCoordinator.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class ApplicationCoordinator: BaseCoordinator {
    
    private let bag = DisposeBag()
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        runAuthFlow()
    }
    
    private func runAuthFlow() {
        let coordinator = coordinatorFactory.generateAuthCoordinator(router: router)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.runMainTabbarFlow()
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start()
    }
    
    private func runMainTabbarFlow() {
        let (view, coordinator) = coordinatorFactory.generateTabbarCoordinator()
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.runAuthFlow()
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        router.setRoot(presentable: view, hideBar: true)
        coordinator.start()
    }
    
}
