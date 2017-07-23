//
//  CoordinatorFactoryImpl.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class CoordinatorFactoryImpl: CoordinatorFactory {
    
    func generateTabbarCoordinator() -> (presentable: Presentable?, coordinator: Coordinator) {
        let tabbarController = UIStoryboard.instantiateInitialViewController(withType: TabbarController.self)
        let tabbarCoordinator = TabbarCoordinator(tabSelected: tabbarController, coordinatorFactory: CoordinatorFactoryImpl())
        return (tabbarController, tabbarCoordinator)
    }
    
    func generateAuthCoordinator(router: Router) -> Coordinator {
        return AuthCoordinator(viewFactory: ViewFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
    }
    
}
