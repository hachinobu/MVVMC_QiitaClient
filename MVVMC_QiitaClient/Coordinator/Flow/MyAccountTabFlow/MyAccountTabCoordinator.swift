//
//  MyAccountTabCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class MyAccountTabCoordinator: BaseCoordinator {

    private let bag = DisposeBag()
    private let moduleFactory: MyAccountModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(moduleFactory: MyAccountModuleFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showMyAccountView()
    }
    
    private func showMyAccountView() {
        
        let myAccountView = moduleFactory.generateUserDetailView()
        let userRequest = QiitaAPI.GetAuthenticatedUserRequest()
        let userTransformer = UserEntityToUserDetailTableCellViewModelTransform()
        let myItemsRequest = QiitaAPI.GetAuthUserItemsRequest(page: 1, perPage: 20)
        let myItemsTransformer = ItemEntityToCellViewModelTransform()
        let viewModel = UserDetailVM(userRequest: userRequest, itemsRequest: myItemsRequest, userTransformer: userTransformer, itemTransformer: myItemsTransformer)
        myAccountView.injectViewModel(viewModel: viewModel)
        
        myAccountView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showMyItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        myAccountView.selectedFollowTagList.subscribe(onNext: { [weak self] userId in
            self?.showUserFollowTagList(userId: userId)
        }).addDisposableTo(bag)
        
        myAccountView.selectedFollowee.subscribe(onNext: { [weak self] userId in
            self?.showFolloweeList(userId: userId)
        }).addDisposableTo(bag)
        
        myAccountView.selectedFollower.subscribe(onNext: { [weak self] userId in
            self?.showFollowerList(userId: userId)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: myAccountView, hideBar: false)
        
    }
    
    private func showMyItemDetail(itemId: String) {
        let itemDetailView = moduleFactory.generateItemDetailView()
        
        let itemDetailRequest = QiitaAPI.GetItemDetailRequest(itemId: itemId)
        let itemStockerRequest = QiitaAPI.GetItemStockersRequest(itemId: itemId)
        let transformer = ItemAndCountEntityToItemDetailViewModel()
        let stockStatusRequet = QiitaAPI.GetStockStatusRequest(itemId: itemId)
        let putStockRequest = QiitaAPI.PutStockStatusRequest(itemId: itemId)
        let deleteStockRequest = QiitaAPI.DeleteStockStatusRequest(itemId: itemId)
        let viewModel = ItemDetailVM(itemRequest: itemDetailRequest, countRequest: itemStockerRequest, transformer: transformer, stockStatusRequest: stockStatusRequet, putStockRequest: putStockRequest, deleteStockRequest: deleteStockRequest)
        itemDetailView.injectViewModel(viewModel: viewModel)
        
        itemDetailView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.router.pop(animated: true)
        }).addDisposableTo(bag)
        
        router.push(presentable: itemDetailView, animated: true, completion: nil)
    }
    
    private func showItemDetail(itemId: String) {
        let itemDetailView = moduleFactory.generateItemDetailView()
        
        let itemDetailRequest = QiitaAPI.GetItemDetailRequest(itemId: itemId)
        let itemStockerRequest = QiitaAPI.GetItemStockersRequest(itemId: itemId)
        let transformer = ItemAndCountEntityToItemDetailViewModel()
        let stockStatusRequet = QiitaAPI.GetStockStatusRequest(itemId: itemId)
        let putStockRequest = QiitaAPI.PutStockStatusRequest(itemId: itemId)
        let deleteStockRequest = QiitaAPI.DeleteStockStatusRequest(itemId: itemId)
        let viewModel = ItemDetailVM(itemRequest: itemDetailRequest, countRequest: itemStockerRequest, transformer: transformer, stockStatusRequest: stockStatusRequet, putStockRequest: putStockRequest, deleteStockRequest: deleteStockRequest)
        itemDetailView.injectViewModel(viewModel: viewModel)
        
        itemDetailView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: itemDetailView, animated: true, completion: nil)
        
    }
    
    private func showUserDetail(userId: String) {
        
        let userDetailView = moduleFactory.generateUserDetailView()
        let userRequest = QiitaAPI.GetUserDetailRequest(userId: userId)
        let userTransformer = UserEntityToUserDetailTableCellViewModelTransform()
        let userItemsRequest = QiitaAPI.GetUserItemsRequest(userId: userId, page: 1)
        let userItemsTransformer = ItemEntityToCellViewModelTransform()
        let viewModel = UserDetailVM(userRequest: userRequest, itemsRequest: userItemsRequest, userTransformer: userTransformer, itemTransformer: userItemsTransformer)
        userDetailView.injectViewModel(viewModel: viewModel)
        
        userDetailView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        userDetailView.selectedFollowTagList.subscribe(onNext: { [weak self] userId in
            self?.showUserFollowTagList(userId: userId)
        }).addDisposableTo(bag)
        
        userDetailView.selectedFollowee.subscribe(onNext: { [weak self] userId in
            self?.showFolloweeList(userId: userId)
        }).addDisposableTo(bag)
        
        userDetailView.selectedFollower.subscribe(onNext: { [weak self] userId in
            self?.showFollowerList(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: userDetailView, animated: true, completion: nil)
        
    }
    
    private func showFolloweeList(userId: String) {
        
        let userListView = moduleFactory.generateUserListView()
        let followerRequest = QiitaAPI.GetFolloweesRequest(userId: userId, page: 1)
        let transformer = UserEntityToUserListTableCellVMTransform()
        let viewModel = UserListVM(request: followerRequest, transformer: transformer)
        userListView.injectViewModel(viewModel: viewModel)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
    
    private func showFollowerList(userId: String) {
        
        let userListView = moduleFactory.generateUserListView()
        let followerRequest = QiitaAPI.GetFollowersRequest(userId: userId, page: 1)
        let transformer = UserEntityToUserListTableCellVMTransform()
        let viewModel = UserListVM(request: followerRequest, transformer: transformer)
        userListView.injectViewModel(viewModel: viewModel)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
    
    private func showUserFollowTagList(userId: String) {
        
        let tagListView = moduleFactory.generateTagListView()
        let userFollowTagRequest = QiitaAPI.GetUserFollowTagsRequest(userId: userId, page: 1, perPage: 20)
        let transformer = TagEntityToTagListTableCellVMTransform()
        let viewModel = TagListVM(request: userFollowTagRequest, transformer: transformer)
        tagListView.injectViewModel(viewModel: viewModel)
        
        tagListView.selectedTagId.subscribe(onNext: { [weak self] tagId in
            self?.showTagItemList(tagId: tagId)
        }).addDisposableTo(bag)
        
        router.push(presentable: tagListView, animated: true, completion: nil)
        
    }
    
    private func showTagItemList(tagId: String) {
        
        let itemListView = moduleFactory.generateTagItemListView()
        let tagItemsRequest = QiitaAPI.GetTagItemsRequest(tagId: tagId, page: 1, perPage: 20)
        let transform = ItemEntityToCellViewModelTransform()
        let viewModel = ItemListVM(request: tagItemsRequest, transformer: transform)
        itemListView.injectViewModel(viewModel: viewModel)
        
        itemListView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        itemListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: itemListView, animated: true, completion: nil)
        
    }
    
}
