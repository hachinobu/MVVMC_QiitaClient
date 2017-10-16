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
    func generateUserDetailView(userId: String) -> UserDetailViewType & Presentable
    func generateFolloweeUserListView(userId: String) -> UserListViewType & Presentable
    func generateFollowerUserListView(userId: String) -> UserListViewType & Presentable
    func generateUserFollowTagListView(userId: String) -> TagListViewType & Presentable
    func generateTagItemListView(tagId: String) -> ItemListViewType & Presentable
    func generateLikeUserListView(itemId: String) -> UserListViewType & Presentable
    func generateStockUserListView(itemId: String) -> UserListViewType & Presentable
}
