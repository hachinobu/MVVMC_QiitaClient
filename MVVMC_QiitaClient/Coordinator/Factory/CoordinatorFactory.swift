//
//  CoordinatorFactory.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol CoordinatorFactory {
    func generateTabbarCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType
    func generateNoAuthTabbarCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType & ItemCoordinatorFinishFlowType
    func generateAuthCoordinator(router: Router) -> Coordinator & CoordinatorFinishFlowType
    func generateItemTabCoordinator(navigationController: UINavigationController?) -> Coordinator & ItemCoordinatorFinishFlowType
    func generateTagTabCoordinator(navigationController: UINavigationController?) -> Coordinator
    func generateUserCoordinator(navigationController: UINavigationController?) -> Coordinator & CoordinatorFinishFlowType
    func generateSignInTabCoordinator(navigationController: UINavigationController?) -> Coordinator & CoordinatorFinishFlowType
    func generateAuthCoordinatorBox() -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType))
    func generateItemCoordinatorBox(navigationController: UINavigationController?) -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType))
    func generateTagCoordinatorBox(navigationController: UINavigationController?) -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType))
    func generateUserCoordinatorBox(navigationController: UINavigationController?) -> (presentable: Presentable?, coordinator: (Coordinator & CoordinatorFinishFlowType))
}
