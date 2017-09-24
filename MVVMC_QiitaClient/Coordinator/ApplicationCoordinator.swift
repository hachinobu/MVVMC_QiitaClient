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
    
    override func start(option: DeepLinkOption) {
        if hasAccessToken {
            if childCoordinators.isEmpty {
                runMainTabbarFlow(option: option)
            } else {
                childCoordinators.forEach { $0.start(option: option) }
            }
            runMainTabbarFlow(option: option)
        } else {
            start()
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
    
    private func runMainTabbarFlow(option: DeepLinkOption? = nil) {
        let coordinator = coordinatorFactory.generateTabbarCoordinator(router: router)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.start()
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        if let option = option {
            coordinator.start(option: option)
        } else {
            coordinator.start()
        }
    }
    
    private func runNoAuthTabbarFlow() {
        let coordinator = coordinatorFactory.generateNoAuthTabbarCoordinator(router: router)
        coordinator.finishItemFlow.subscribe(onNext: { [weak self, weak coordinator] option in
            self?.start(option: option)
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start()
    }
    
}
