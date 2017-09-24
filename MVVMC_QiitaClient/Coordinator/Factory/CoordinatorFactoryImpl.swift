//
//  CoordinatorFactoryImpl.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class CoordinatorFactoryImpl: CoordinatorFactory {
    
    func generateTabbarCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType {
        let tabbarCoordinator = TabbarCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
        return tabbarCoordinator
    }
    
    func generateNoAuthTabbarCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType & ItemCoordinatorFinishFlowType {
        let noAuthTabbarCoordinator = NoAuthTabbarCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
        return noAuthTabbarCoordinator
    }
    
    func generateAuthCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType {
        return AuthCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
    }
    
    func generateItemTabCoordinator(navigationController: UINavigationController?) -> Coordinator & ItemCoordinatorFinishFlowType {
        let rootController = navigationController ?? UINavigationController()
        return HomeTabCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateTagTabCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let rootController = navigationController ?? UINavigationController()
        return TagTabCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateMyAccountTabCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let rootController = navigationController ?? UINavigationController()
        return MyAccountTabCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateAuthCoordinatorBox() -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType)) {
        let navigation = UIStoryboard.instantiateInitialViewController(withType: PresentNavigationController.self)
        let router = RouterImpl(rootController: navigation)
        let coordinator = AuthCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
        return (router, coordinator)
    }
    
}
