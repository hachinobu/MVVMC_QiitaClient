//
//  HomeTabCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class HomeTabCoordinator: BaseCoordinator, ItemCoordinatorFinishFlowType {
    
    private let finishItemFlowObserver = PublishSubject<DeepLinkOption>()
    lazy var finishItemFlow: Observable<DeepLinkOption> = self.finishItemFlowObserver.asObservable()
    
    private let bag = DisposeBag()
    private let moduleFactory: ItemModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(moduleFactory: ItemModuleFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showAllItemList()
    }
    
    override func start(option: DeepLinkOption) {
        if option.hasItemId() {
            showItemDetail(itemId: option.linkId()!)
        }
    }
    
    private func showAllItemList() {
        
        let itemListView = moduleFactory.generateAllItemListView()        
        itemListView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        itemListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: itemListView, hideBar: false)
        
    }
    
    private func showItemDetail(itemId: String) {
        let itemDetailView = moduleFactory.generateItemDetailView(itemId: itemId)
        itemDetailView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        itemDetailView.requiredAuth.subscribe(onNext: { [weak self] _ in
            self?.runAuthFlow(option: DeepLinkOption.item(itemId))
        }).addDisposableTo(bag)
        
        router.push(presentable: itemDetailView, animated: true, completion: nil)
    }
    
    private func runAuthFlow(option: DeepLinkOption) {
        
        let (module, coordinator) = coordinatorFactory.generateAuthCoordinatorBox()
        coordinator.finishFlow.do(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
        }).filter { AccessTokenStorage.hasAccessToken() && option.hasItemId() }
            .map { option }
            .bind(to: finishItemFlowObserver)
            .addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start()
        router.present(presentable: module, animated: true)
        
    }
    
    private func showUserDetail(userId: String) {
        
        let userDetailView = moduleFactory.generateUserDetailView(userId: userId)
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
        
        let userListView = moduleFactory.generateFolloweeUserListView(userId: userId)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
    
    private func showFollowerList(userId: String) {
        
        let userListView = moduleFactory.generateFollowerUserListView(userId: userId)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
    
    private func showUserFollowTagList(userId: String) {
        
        let tagListView = moduleFactory.generateUserFollowTagListView(userId: userId)
        
        tagListView.selectedTagId.subscribe(onNext: { [weak self] tagId in
            self?.showTagItemList(tagId: tagId)
        }).addDisposableTo(bag)
        
        router.push(presentable: tagListView, animated: true, completion: nil)
        
    }
    
    private func showTagItemList(tagId: String) {
        
        let itemListView = moduleFactory.generateTagItemListView(tagId: tagId)
        
        itemListView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        itemListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: itemListView, animated: true, completion: nil)
        
    }
    
}
