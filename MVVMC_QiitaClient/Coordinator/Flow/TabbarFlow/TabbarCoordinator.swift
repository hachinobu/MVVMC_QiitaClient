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
            self.runHomeTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabbarView.selectedTagTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runTagTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabbarView.selectedMyAccountTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runMyAccountTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        runHomeTabFlow(navigationController: tabbarView.itemTabNavigationController)
        
        router.setRoot(presentable: tabbarView, hideBar: true)
        
    }
    
    override func start(option: DeepLinkOption) {
        
        if childCoordinators.isEmpty {
            start()
        }
        
        switch option {
        case .item(_):
            if let coordinator = childCoordinators.filter ({ $0 is HomeTabCoordinator }).first {
                coordinator.start(option: option)
            } else if let navigationController = router.toPresent().flatMap({ $0 as? TabbarController })?.itemTabNavigationController {
                runHomeTabFlow(navigationController: navigationController, option: option)
            }
        case .tag(_):
            if let coordinator = childCoordinators.filter({ $0 is TagTabCoordinator }).first {
                coordinator.start(option: option)
            } else if let navigationController = router.toPresent().flatMap({ $0 as? TabbarController })?.tagTabNavigationController {
                runTagTabFlow(navigationController: navigationController, option: option)
            }
        case .myAccount:
            if let coordinator = childCoordinators.filter({ $0 is MyAccountTabCoordinator }).first {
                coordinator.start(option: option)
            } else if let navigationController = router.toPresent().flatMap({ $0 as? TabbarController })?.tagTabNavigationController {
                runTagTabFlow(navigationController: navigationController, option: option)
            }
        }
        
        
        
//        childCoordinators.forEach { coordinator in
//            switch coordinator {
//            case is AuthCoordinator:
//                print("")
//            case _:
//                print("")
//            }
//        }
//
//        if childCoordinators.isEmpty {
//
//            let tabbarView = moduleFactory.generateAuthTabView()
//
//            tabbarView.selectedItemTabObservable.subscribe(onNext: { [unowned self] navigationController in
//                self.runHomeTabFlow(navigationController: navigationController, option: option)
//            }).addDisposableTo(bag)
//
//            tabbarView.selectedTagTabObservable.subscribe(onNext: { [unowned self] navigationController in
//                self.runTagTabFlow(navigationController: navigationController)
//            }).addDisposableTo(bag)
//
//            tabbarView.selectedMyAccountTabObservable.subscribe(onNext: { [unowned self] navigationController in
//                self.runMyAccountTabFlow(navigationController: navigationController)
//            }).addDisposableTo(bag)
//
//            router.setRoot(presentable: tabbarView, hideBar: true)
//
//        } else {
//            childCoordinators.forEach { $0.start(option: option) }
//        }
        
    }
    
    private func runHomeTabFlow(navigationController: UINavigationController, option: DeepLinkOption? = nil) {
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
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
}
