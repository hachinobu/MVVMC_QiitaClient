//
//  ItemModuleFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol ItemModuleFactory {
    func generateAllItemListView() -> ItemListViewType & Presentable
    func generateItemDetailView(itemId: String) -> ItemDetailViewType & Presentable
    func generateTagItemListView(tagId: String) -> ItemListViewType & Presentable
}
