//
//  HomeTabViewFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol HomeTabViewFactory {
    func generateHomeItemListView() -> ItemListViewType & Presentable
}