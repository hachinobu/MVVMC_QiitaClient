//
//  HomeTabCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class HomeTabCoordinator: BaseCoordinator {
    
    private let bag = DisposeBag()
    private let viewFactory: HomeTabViewFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(viewFactory: HomeTabViewFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.viewFactory = viewFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showAllItemList()
    }
    
    private func showAllItemList() {
        let itemListView = viewFactory.generateHomeItemListView()
        let request = QiitaAPI.GetItemsRequest(page: 1)
        let transform = ItemEntityToCellViewModelTransform()
        let viewModel = HomeItemListVM(request: request, transformer: transform)
        itemListView.injectViewModel(viewModel: viewModel)
        
        itemListView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        itemListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: itemListView, hideBar: false)
        
    }
    
    private func showItemDetail(itemId: String) {
        let itemDetailView = viewFactory.generateItemDetailView()
        
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
        
        let userDetailView = viewFactory.generateUserDetailView()
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
        
        let userListView = viewFactory.generateUserListView()
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
        
        let userListView = viewFactory.generateUserListView()
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
        
        let tagListView = viewFactory.generateTagListView()
        let userFollowTagRequest = QiitaAPI.GetUserFollowTagsRequest(userId: userId, page: 1, perPage: 20)
        let transformer = TagEntityToTagListTableCellVMTransform()
        let viewModel = TagListVM(request: userFollowTagRequest, transformer: transformer)
        tagListView.injectViewModel(viewModel: viewModel)
        
        tagListView.selectedTag.subscribe(onNext: { tag in
            print(tag)
        }).addDisposableTo(bag)
        
        router.push(presentable: tagListView, animated: true, completion: nil)
        
    }
    
}
