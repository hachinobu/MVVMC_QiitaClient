//
//  NavigationModuleFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol NavigationModuleFactory {
    func generateNavigationView() -> Router
}
