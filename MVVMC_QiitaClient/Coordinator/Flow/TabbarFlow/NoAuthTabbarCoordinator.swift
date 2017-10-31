//
//  NoAuthTabbarCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class NoAuthTabbarCoordinator: BaseCoordinator, CoordinatorFinishFlowType, ItemCoordinatorFinishFlowType {
    
    private let bag = DisposeBag()
    
    private let moduleFactory: TabModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow: Observable<Void> = self.finishFlowObserver.asObservable()
    
    private let finishItemFlowObserver = PublishSubject<DeepLinkOption>()
    lazy var finishItemFlow: Observable<DeepLinkOption> = self.finishItemFlowObserver.asObservable()
    
    init(moduleFactory: TabModuleFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        
        let tabView = moduleFactory.generateNoAuthTabView()
        
        tabView.selectedItemTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runItemTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabView.selectedTagTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runTagTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabView.selectedSignInTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runSignInTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: tabView, hideBar: true)
        
    }
    
    private func runItemTabFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateItemTabCoordinator(navigationController: navigationController)
        coordinator.finishItemFlow
            .filter { _ in AccessTokenStorage.hasAccessToken() }
            .bind(to: finishItemFlowObserver)
            .addDisposableTo(bag)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runTagTabFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateTagTabCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runSignInTabFlow(navigationController: UINavigationController) {
        AuthenticateQiita.sharedInstance.status.value = .loginFromAccount
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateSignInTabCoordinator(navigationController: navigationController)
        coordinator.finishFlow
            .filter { AccessTokenStorage.hasAccessToken() }
            .bind(to: finishFlowObserver)
            .addDisposableTo(bag)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
}
