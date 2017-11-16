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
        return ItemCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateTagTabCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let rootController = navigationController ?? UINavigationController()
        return TagCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateSignInTabCoordinator(navigationController: UINavigationController?) -> Coordinator & CoordinatorFinishFlowType {
        let rootController = navigationController ?? UINavigationController()
        return AuthCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateUserCoordinator(navigationController: UINavigationController?) -> Coordinator & CoordinatorFinishFlowType {
        let rootController = navigationController ?? UINavigationController()
        return UserCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateAuthCoordinatorBox() -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType)) {
        let navigation = UIStoryboard.instantiateInitialViewController(withType: PresentNavigationController.self)
        let router = RouterImpl(rootController: navigation)
        let coordinator = AuthCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
        return (router, coordinator)
    }
    
    func generateItemCoordinatorBox(navigationController: UINavigationController?) -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType)) {
        let rootController = navigationController ?? UINavigationController()
        let router = RouterImpl(rootController: rootController)
        let coordinator = ItemCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
        return (router, coordinator)
    }
    
    func generateTagCoordinatorBox(navigationController: UINavigationController?) -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType)) {
        let rootController = navigationController ?? UINavigationController()
        let router = RouterImpl(rootController: rootController)
        let coordinator = TagCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
        return (router, coordinator)
    }
    
    func generateUserCoordinatorBox(navigationController: UINavigationController?) -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType)) {
        let rootController = navigationController ?? UINavigationController()
        let router = RouterImpl(rootController: rootController)
        let coordinator = UserCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
        return (router, coordinator)
    }
    
}
