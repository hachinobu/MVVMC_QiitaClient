//
//  ModuleFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class ModuleFactory {
}

//AuthFlow
extension ModuleFactory: AuthModuleFactory {
    
    func generateAuthView() -> AuthViewType & Presentable {
        let authView = UIStoryboard.instantiateInitialViewController(withType: AuthViewController.self)
        let authRequest = QiitaAPI.PostAccessTokenRequest(clientId: AuthInfo.clientId, clientSecret: AuthInfo.clientSecret)
        let viewModel = AuthVM(request: authRequest)
        authView.injectViewModel(viewModel: viewModel)
        
        return authView
    }
    
}

extension ModuleFactory: NavigationModuleFactory {
    
    func generateNavigationView() -> Router {
        let navigation = UIStoryboard.instantiateInitialViewController(withType: PresentNavigationController.self)
        let router = RouterImpl(rootController: navigation)
        return router
    }
    
}

extension ModuleFactory: TabModuleFactory {
    
    func generateAuthTabView() -> Presentable & TabSelectableView {
        return UIStoryboard.instantiateInitialViewController(withType: TabbarController.self)
    }
    
    func generateNoAuthTabView() -> NoAuthTabSelectable & Presentable {
        return UIStoryboard.instantiateInitialViewController(withType: NoAuthTabbarController.self)
    }
    
}

extension ModuleFactory: ItemModuleFactory {
    
    func generateAllItemListView() -> ItemListViewType & Presentable {
        let itemListView = UIStoryboard.instantiateInitialViewController(withType: ItemListViewController.self)
        let request = QiitaAPI.GetItemsRequest()
        let transform = ItemEntityToCellViewModelTransform()
        let viewModel = ItemListVM(request: request, transformer: transform)
        itemListView.injectViewModel(viewModel: viewModel)
        
        return itemListView
    }
    
    func generateItemDetailView(itemId: String) -> ItemDetailViewType & Presentable {
        let itemDetailView = UIStoryboard.instantiateInitialViewController(withType: ItemDetailViewController.self)
        let itemDetailRequest = QiitaAPI.GetItemDetailRequest(itemId: itemId)
        let itemStockerRequest = QiitaAPI.GetItemStockersRequest(itemId: itemId)
        let transformer = ItemAndCountEntityToItemDetailViewModel()
        let getStatusRequet = QiitaAPI.GetLikeStatusRequest(itemId: itemId)
        let putStatusRequest = QiitaAPI.PutLikeStatusRequest(itemId: itemId)
        let deleteStatusRequest = QiitaAPI.DeleteLikeStatusRequest(itemId: itemId)
        
        let viewModel = ItemDetailVM(itemRequest: itemDetailRequest, countRequest: itemStockerRequest, transformer: transformer,
                                     getStatusRequest: getStatusRequet, putStatusRequest: putStatusRequest, deleteStatusRequest: deleteStatusRequest)
        itemDetailView.injectViewModel(viewModel: viewModel)
        
        return itemDetailView
    }
    
    func generateTagItemListView(tagId: String) -> ItemListViewType & Presentable {
        let itemListView = UIStoryboard.instantiateInitialViewController(withType: ItemListViewController.self)
        let tagItemsRequest = QiitaAPI.GetTagItemsRequest(tagId: tagId)
        let transform = ItemEntityToCellViewModelTransform()
        let viewModel = ItemListVM(request: tagItemsRequest, transformer: transform)
        itemListView.injectViewModel(viewModel: viewModel)
        
        return itemListView
    }
        
}

extension ModuleFactory: TagModuleFactory {
    
    func generateAllTagListView() -> TagListViewType & Presentable {
        let tagListView = UIStoryboard.instantiateInitialViewController(withType: TagListViewController.self)
        let tagsRequest = QiitaAPI.GetTagsRequest()
        let transformer = TagEntityToTagListTableCellVMTransform()
        let viewModel = TagListVM(request: tagsRequest, transformer: transformer)
        tagListView.injectViewModel(viewModel: viewModel)
        
        return tagListView
    }
    
    func generateUserFollowTagListView(userId: String) -> TagListViewType & Presentable {
        let tagListView = UIStoryboard.instantiateInitialViewController(withType: TagListViewController.self)
        let userFollowTagRequest = QiitaAPI.GetUserFollowTagsRequest(userId: userId)
        let transformer = TagEntityToTagListTableCellVMTransform()
        let viewModel = TagListVM(request: userFollowTagRequest, transformer: transformer)
        tagListView.injectViewModel(viewModel: viewModel)
        
        return tagListView
    }
    
}

extension ModuleFactory: UserModuleFactory {
    
    func generateMyAccountView() -> UserDetailViewType & Presentable {
        let myAccountView = UIStoryboard.instantiateInitialViewController(withType: UserDetailViewController.self)
        let userRequest = QiitaAPI.GetAuthenticatedUserRequest()
        let userTransformer = UserEntityToUserDetailTableCellViewModelTransform()
        let myItemsRequest = QiitaAPI.GetAuthUserItemsRequest()
        let myItemsTransformer = ItemEntityToCellViewModelTransform()
        let viewModel = UserDetailVM(userRequest: userRequest, itemsRequest: myItemsRequest, userTransformer: userTransformer, itemTransformer: myItemsTransformer)
        myAccountView.injectViewModel(viewModel: viewModel)
        myAccountView.isDisplayButton = true
        
        return myAccountView
    }
    
    func generateUserDetailView(userId: String) -> UserDetailViewType & Presentable  {
        let userDetailView = UIStoryboard.instantiateInitialViewController(withType: UserDetailViewController.self)
        let userRequest = QiitaAPI.GetUserDetailRequest(userId: userId)
        let userTransformer = UserEntityToUserDetailTableCellViewModelTransform()
        let userItemsRequest = QiitaAPI.GetUserItemsRequest(userId: userId)
        let userItemsTransformer = ItemEntityToCellViewModelTransform()
        let viewModel = UserDetailVM(userRequest: userRequest, itemsRequest: userItemsRequest,
                                     userTransformer: userTransformer, itemTransformer: userItemsTransformer)
        userDetailView.injectViewModel(viewModel: viewModel)
        
        return userDetailView
    }
    
    func generateFolloweeUserListView(userId: String) -> UserListViewType & Presentable  {
        let userListView = UIStoryboard.instantiateInitialViewController(withType: UserListViewController.self)
        let followerRequest = QiitaAPI.GetFolloweesRequest(userId: userId)
        let transformer = UserEntityToUserListTableCellVMTransform()
        let viewModel = UserListVM(request: followerRequest, transformer: transformer)
        userListView.injectViewModel(viewModel: viewModel)
        
        return userListView
    }
    
    func generateFollowerUserListView(userId: String) -> UserListViewType & Presentable {
        let userListView = UIStoryboard.instantiateInitialViewController(withType: UserListViewController.self)
        let followerRequest = QiitaAPI.GetFollowersRequest(userId: userId)
        let transformer = UserEntityToUserListTableCellVMTransform()
        let viewModel = UserListVM(request: followerRequest, transformer: transformer)
        userListView.injectViewModel(viewModel: viewModel)
        
        return userListView
    }
    
    func generateLikeUserListView(itemId: String) -> UserListViewType & Presentable {
        let userListView = UIStoryboard.instantiateInitialViewController(withType: UserListViewController.self)
        let likeUserRequest = QiitaAPI.GetItemLikesRequest(itemId: itemId)
        let transform = LikeUserEntityToUserListTableCellVMTransform()
        let viewModel = UserListVM(request: likeUserRequest, transformer: transform)
        userListView.injectViewModel(viewModel: viewModel)
        
        return userListView
    }
    
    func generateStockUserListView(itemId: String) -> UserListViewType & Presentable {
        let userListView = UIStoryboard.instantiateInitialViewController(withType: UserListViewController.self)
        let stockUserRequest = QiitaAPI.GetItemStocksRequest(itemId: itemId)
        let transformer = UserEntityToUserListTableCellVMTransform()
        let viewModel = UserListVM(request: stockUserRequest, transformer: transformer)
        userListView.injectViewModel(viewModel: viewModel)
        
        return userListView
    }
    
}
