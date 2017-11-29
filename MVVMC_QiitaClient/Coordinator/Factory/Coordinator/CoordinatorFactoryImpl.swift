//
//  CoordinatorFactoryImpl.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class CoordinatorFactoryImpl: CoordinatorFactory {
    
    func generateAuthenticatedCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType {
        return AuthenticatedCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
    }
    
    func generateUnAuthenticatedCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType & ItemCoordinatorFinishFlowType {
        return UnAuthenticatedCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
    }
    
    func generateAuthenticationCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType {
        return AuthenticationCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
    }
    
    func generateItemCoordinator(navigationController: UINavigationController?) -> Coordinator & ItemCoordinatorFinishFlowType {
        let rootController = navigationController ?? UINavigationController()
        return ItemCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateTagCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let rootController = navigationController ?? UINavigationController()
        return TagCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateLogInTabCoordinator(navigationController: UINavigationController?) -> Coordinator & CoordinatorFinishFlowType {
        let rootController = navigationController ?? UINavigationController()
        return AuthenticationCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateUserCoordinator(navigationController: UINavigationController?) -> Coordinator & CoordinatorFinishFlowType {
        let rootController = navigationController ?? UINavigationController()
        return UserCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: RouterImpl(rootController: rootController))
    }
    
    func generateAuthCoordinatorBox() -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType)) {
        let navigation = UIStoryboard.instantiateInitialViewController(withType: PresentNavigationController.self)
        let router = RouterImpl(rootController: navigation)
        let coordinator = AuthenticationCoordinator(moduleFactory: ModuleFactory(), coordinatorFactory: CoordinatorFactoryImpl(), router: router)
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
