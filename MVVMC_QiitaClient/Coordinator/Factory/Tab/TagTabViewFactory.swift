//
//  TagTabViewFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/31.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol TagTabViewFactory {
    func generateTagListView() -> TagListViewType & Presentable
}
