//
//  UnAuthenticatedCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class UnAuthenticatedCoordinator: BaseCoordinator, CoordinatorFinishFlowType, ItemCoordinatorFinishFlowType {
    
    private let bag = DisposeBag()
    
    private let moduleFactory: UnAuthenticatedModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow: Observable<Void> = self.finishFlowObserver.asObservable()
    
    private let finishItemFlowObserver = PublishSubject<DeepLinkOption>()
    lazy var finishItemFlow: Observable<DeepLinkOption> = self.finishItemFlowObserver.asObservable()
    
    init(moduleFactory: UnAuthenticatedModuleFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        
        let tabView = moduleFactory.generateUnAuthenticatedTabView()
        
        tabView.selectedItemTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runItemTabFlow(navigationController: navigationController)
        }).disposed(by: bag)
        
        tabView.selectedTagTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runTagTabFlow(navigationController: navigationController)
        }).disposed(by: bag)
        
        tabView.selectedSignInTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runLoginTabFlow(navigationController: navigationController)
        }).disposed(by: bag)
        
        router.setRoot(presentable: tabView, hideBar: true)
        
    }
    
    private func runItemTabFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateItemCoordinator(navigationController: navigationController)
        coordinator.finishItemFlow
            .filter { _ in AccessTokenStorage.hasAccessToken() }
            .bind(to: finishItemFlowObserver)
            .disposed(by: bag)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runTagTabFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateTagCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runLoginTabFlow(navigationController: UINavigationController) {
        AuthenticateQiita.sharedInstance.status.value = .loginFromAccount
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateLogInTabCoordinator(navigationController: navigationController)
        coordinator.finishFlow
            .filter { AccessTokenStorage.hasAccessToken() }
            .bind(to: finishFlowObserver)
            .disposed(by: bag)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
}
