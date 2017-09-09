//
//  TagTabCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/31.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class TagTabCoordinator: BaseCoordinator {
    
    typealias TagModule = ItemModuleFactory & TagModuleFactory
    
    private let bag = DisposeBag()
    private let moduleFactory: TagModule
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(moduleFactory: TagModule, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showAllTagListView()
    }
    
    private func showAllTagListView() {
        
        let tagListView = moduleFactory.generateAllTagListView()
        
        tagListView.selectedTagId.subscribe(onNext: { [weak self] tagId in
            self?.showTagItemList(tagId: tagId)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: tagListView, hideBar: false)
        
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

    private func showItemDetail(itemId: String) {
        let itemDetailView = moduleFactory.generateItemDetailView(itemId: itemId)

        itemDetailView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).addDisposableTo(bag)

        router.push(presentable: itemDetailView, animated: true, completion: nil)

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
    
}
