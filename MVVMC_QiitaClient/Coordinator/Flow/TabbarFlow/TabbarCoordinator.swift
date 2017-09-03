//
//  TabbarCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class TabbarCoordinator: BaseCoordinator, CoordinatorFinishFlowType {
    
    private let bag = DisposeBag()
    
    private let tabSelected: TabSelectableView
    private let coordinatorFactory: CoordinatorFactory
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow: Observable<Void> = self.finishFlowObserver.asObservable()
    
    init(tabSelected: TabSelectableView, coordinatorFactory: CoordinatorFactory) {
        self.tabSelected = tabSelected
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        
        tabSelected.selectedItemTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runHomeTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabSelected.selectedTagTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runTagTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
        tabSelected.selectedMyAccountTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runMyAccountTabFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
    }
    
    private func runHomeTabFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateItemTabCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runTagTabFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateTagTabCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
    private func runMyAccountTabFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        let coordinator = coordinatorFactory.generateMyAccountTabCoordinator(navigationController: navigationController)
        coordinator.start()
        addDependency(coordinator: coordinator)
    }
    
}
