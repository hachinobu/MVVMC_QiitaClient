//
//  AuthenticatedModuleFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/11/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol AuthenticatedModuleFactory {
    func generateAuthenticatedTabView() -> AuthenticatedTabSelectableView & Presentable
}
