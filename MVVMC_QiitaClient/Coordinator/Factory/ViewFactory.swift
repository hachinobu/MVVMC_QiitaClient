//
//  ViewFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class ViewFactory {
}

//AuthFlow
extension ViewFactory: AuthViewFactory {
    
    func generateAuthView() -> AuthViewProtocol & Presentable {
        let authView = UIStoryboard.instantiateInitialViewController(withType: AuthViewController.self)
        return authView
    }
    
}

extension ViewFactory: HomeTabViewFactory, TagTabViewFactory {
    
    func generateHomeItemListView() -> ItemListViewType & Presentable {
        let homeItemListView = UIStoryboard.instantiateInitialViewController(withType: ItemListViewController.self)
        return homeItemListView
    }
    
    func generateItemDetailView() -> ItemDetailViewType & Presentable {
        let itemDetailView = UIStoryboard.instantiateInitialViewController(withType: ItemDetailViewController.self)
        return itemDetailView
    }
    
    func generateUserDetailView() -> Presentable & UserDetailViewType {
        let userDetailView = UIStoryboard.instantiateInitialViewController(withType: UserDetailViewController.self)
        return userDetailView
    }
    
    func generateUserListView() -> Presentable & UserListViewType {
        let userListView = UIStoryboard.instantiateInitialViewController(withType: UserListViewController.self)
        return userListView
    }
    
    func generateTagListView() -> Presentable & TagListViewType {
        let tagListView = UIStoryboard.instantiateInitialViewController(withType: TagListViewController.self)
        return tagListView
    }
    
}
