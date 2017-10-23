//
//  TabbarCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class TabbarCoordinator: BaseCoordinator, CoordinatorFinishFlowType, ItemCoordinatorFinishFlowType {
    
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
        
        let tabbarView = moduleFactory.generateAuthTabView()
        
        tabbarView.selectedItemTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runItemTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabbarView.selectedTagTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runTagTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabbarView.selectedMyAccountTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runMyAccountTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: tabbarView, hideBar: true)
        
    }
    
    override func start(option: DeepLinkOption) {
        
        if childCoordinators.isEmpty {
            start()
        }
        
        guard let nav = router.toPresent() as? UINavigationController,
            let tabSelectableView = nav.viewControllers.flatMap ({ $0 as? TabSelectableView }).first else {
                return
        }
        
        let coordinator: Coordinator?
        switch option {
        case .item(_):
            tabSelectableView.chnageSelectedTab(index: TabbarController.SelectedTab.item.rawValue)
            coordinator = childCoordinators.flatMap { $0 as? ItemTabCoordinator }.first
        case .tag(_):
            tabSelectableView.chnageSelectedTab(index: TabbarController.SelectedTab.tag.rawValue)
            coordinator = childCoordinators.flatMap { $0 as? TagTabCoordinator }.first
        case .myAccount:
            tabSelectableView.chnageSelectedTab(index: TabbarController.SelectedTab.myAccount.rawValue)
            coordinator = childCoordinators.flatMap { $0 as? MyAccountTabCoordinator }.first
        }
        
        coordinator?.start(option: option)
        
    }
    
    private func runItemTabFlow(navigationController: UINavigationController, option: DeepLinkOption? = nil) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateItemTabCoordinator(navigationController: navigationController)
        coordinator.finishItemFlow
            .bind(to: finishItemFlowObserver)
            .addDisposableTo(bag)
        coordinator.start()
        if let option = option {
            coordinator.start(option: option)
        }
        addDependency(coordinator: coordinator)
    }
    
    private func runTagTabFlow(navigationController: UINavigationController, option: DeepLinkOption? = nil) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateTagTabCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runMyAccountTabFlow(navigationController: UINavigationController, option: DeepLinkOption? = nil) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateMyAccountTabCoordinator(navigationController: navigationController)
        coordinator.finishFlow
            .bind(to: finishFlowObserver)
            .addDisposableTo(bag)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
}
