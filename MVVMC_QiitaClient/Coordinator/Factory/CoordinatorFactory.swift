//
//  CoordinatorFactory.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol CoordinatorFactory {
    func generateTabbarCoordinator() -> (presentable: Presentable?, coordinator: Coordinator)
    func generateAuthCoordinator(router: Router) -> Coordinator & AuthCoordinatorOutput
}
