//
//  TabbarCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class TabbarCoordinator: BaseCoordinator {
    
    private let bag = DisposeBag()
    
    private let tabSelected: TabSelectable
    private let coordinatorFactory: CoordinatorFactory
    
    init(tabSelected: TabSelectable, coordinatorFactory: CoordinatorFactory) {
        self.tabSelected = tabSelected
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        
        tabSelected.selectedTimeLineTabObservable.subscribe(onNext: { [unowned self] navigationController in
            self.runTimeLineFlow(navigationController: navigationController)
        }).addDisposableTo(bag)
        
    }
    
    private func runTimeLineFlow(navigationController: UINavigationController) {
        guard navigationController.viewControllers.isEmpty else { return }
        
    }
    
}
