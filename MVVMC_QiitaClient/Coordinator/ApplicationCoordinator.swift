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
        return AuthenticateQiita.sharedInstance.status.value.isSkip()
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
            runAuthenticatedFlow()
        } else if isSkipAuth {
            runUnAuthenticatedFlow()
        } else {
            runAuthenticationFlow()
        }
    }
    
    override func start(option: DeepLinkOption) {
        if hasAccessToken {
            if childCoordinators.isEmpty {
                runAuthenticatedFlow(option: option)
            } else {
                childCoordinators.forEach { $0.start(option: option) }
            }
        } else {
            start()
        }
    }
    
}

extension ApplicationCoordinator {
    
    private func runAuthenticationFlow() {
        let coordinator = coordinatorFactory.generateAuthenticationCoordinator(router: router)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
            self?.start()
        }).disposed(by: bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start()
    }
    
    private func runAuthenticatedFlow(option: DeepLinkOption? = nil) {
        let coordinator = coordinatorFactory.generateAuthenticatedCoordinator(router: router)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
            self?.start()
        }).disposed(by: bag)
        
        addDependency(coordinator: coordinator)
        if let option = option {
            coordinator.start(option: option)
        } else {
            coordinator.start()
        }
    }
    
    private func runUnAuthenticatedFlow() {
        let coordinator = coordinatorFactory.generateUnAuthenticatedCoordinator(router: router)
        coordinator.finishItemFlow.subscribe(onNext: { [weak self, weak coordinator] option in
            self?.removeDependency(coordinator: coordinator)
            self?.start(option: option)
        }).disposed(by: bag)
        
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] in
            self?.removeDependency(coordinator: coordinator)
            self?.start()
        }).disposed(by: bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start()
    }
    
}
