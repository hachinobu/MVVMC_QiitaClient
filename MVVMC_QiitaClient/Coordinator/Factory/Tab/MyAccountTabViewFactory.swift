//
//  MyAccountTabViewFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol MyAccountTabViewFactory {
    func generateUserDetailView() -> UserDetailViewType & Presentable
}
