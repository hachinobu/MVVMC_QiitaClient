//
//  NoAuthTabbarCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class NoAuthTabbarCoordinator: BaseCoordinator, CoordinatorFinishFlowType {
    
    private let bag = DisposeBag()
    
    private let tabSelected: NoAuthTabSelectable
    private let coordinatorFactory: CoordinatorFactory
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow: Observable<Void> = self.finishFlowObserver.asObservable()
    
    init(tabSelected: NoAuthTabSelectable, coordinatorFactory: CoordinatorFactory) {
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
    
}
