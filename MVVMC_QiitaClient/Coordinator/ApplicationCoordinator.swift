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
    
    private var hasAccessToken: Bool {
        return AccessTokenStorage.hasAccessToken()
    }
    
    private var isSkipAuth: Bool {
        return AuthenticateQiita.sharedInstance.status.value.isSkipAuth()
    }
    
    private let bag = DisposeBag()
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        if hasAccessToken {
            runMainTabbarFlow()
        } else if isSkipAuth {
            runNoAuthTabbarFlow()
        } else {
            runAuthFlow()
        }
    }
    
    private func runAuthFlow() {
        let coordinator = coordinatorFactory.generateAuthCoordinator(router: router)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.start()
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start()
    }
    
    private func runMainTabbarFlow() {
        let (view, coordinator) = coordinatorFactory.generateTabbarCoordinator()
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.start()
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        router.setRoot(presentable: view, hideBar: true)
        coordinator.start()
    }
    
    private func runNoAuthTabbarFlow() {
        let (view, coordinator) = coordinatorFactory.generateNoAuthTabbarCoordinator()
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.start()
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        router.setRoot(presentable: view, hideBar: true)
        coordinator.start()
    }
    
}
