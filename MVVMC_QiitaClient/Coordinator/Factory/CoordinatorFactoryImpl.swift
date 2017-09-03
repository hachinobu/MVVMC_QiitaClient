//
//  CoordinatorFactoryImpl.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class CoordinatorFactoryImpl: CoordinatorFactory {
    
    func generateTabbarCoordinator() -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType)) {
        let tabbarController = UIStoryboard.instantiateInitialViewController(withType: TabbarController.self)
        let tabbarCoordinator = TabbarCoordinator(tabSelected: tabbarController, coordinatorFactory: CoordinatorFactoryImpl())
        return (tabbarController, tabbarCoordinator)
    }
    
    func generateAuthCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType {
        return AuthCoordinator(viewFactory: ViewFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
    }
    
    func generateItemTabCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let rootController = navigationController ?? UINavigationController()
        return HomeTabCoordinator(viewFactory: ViewFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateTagTabCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let rootController = navigationController ?? UINavigationController()
        return TagTabCoordinator(viewFactory: ViewFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateMyAccountTabCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let rootController = navigationController ?? UINavigationController()
        return MyAccountTabCoordinator(viewFactory: ViewFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
}
