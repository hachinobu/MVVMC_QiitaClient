//
//  UserModuleFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/11/07.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol UserModuleFactory {
    func generateMyAccountView() -> UserDetailViewType & Presentable
    func generateUserDetailView(userId: String) -> UserDetailViewType & Presentable
    func generateFolloweeUserListView(userId: String) -> UserListViewType & Presentable
    func generateFollowerUserListView(userId: String) -> UserListViewType & Presentable
    func generateLikeUserListView(itemId: String) -> UserListViewType & Presentable
    func generateStockUserListView(itemId: String) -> UserListViewType & Presentable
}
