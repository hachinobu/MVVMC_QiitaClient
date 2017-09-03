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
    private let viewFactory: MyAccountTabViewFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(viewFactory: MyAccountTabViewFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.viewFactory = viewFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showMyAccountView()
    }
    
    private func showMyAccountView() {
        
        let myAccountView = viewFactory.generateUserDetailView()
        let userRequest = QiitaAPI.GetAuthenticatedUserRequest()
        let userTransformer = UserEntityToUserDetailTableCellViewModelTransform()
        let myItemsRequest = QiitaAPI.GetAuthUserItemsRequest(page: 1, perPage: 20)
        let myItemsTransformer = ItemEntityToCellViewModelTransform()
        let viewModel = UserDetailVM(userRequest: userRequest, itemsRequest: myItemsRequest, userTransformer: userTransformer, itemTransformer: myItemsTransformer)
        myAccountView.injectViewModel(viewModel: viewModel)
        
        myAccountView.selectedItem.subscribe(onNext: { [weak self] itemId in
            print(itemId)
        }).addDisposableTo(bag)
        
        myAccountView.selectedFollowTagList.subscribe(onNext: { [weak self] userId in
//            self?.showUserFollowTagList(userId: userId)
        }).addDisposableTo(bag)
        
        myAccountView.selectedFollowee.subscribe(onNext: { [weak self] userId in
//            self?.showFolloweeList(userId: userId)
        }).addDisposableTo(bag)
        
        myAccountView.selectedFollower.subscribe(onNext: { [weak self] userId in
//            self?.showFollowerList(userId: userId)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: myAccountView, hideBar: false)
        
//        let userRequest = QiitaAPI.GetUserDetailRequest(userId: userId)
//        let userTransformer = UserEntityToUserDetailTableCellViewModelTransform()
//        let userItemsRequest = QiitaAPI.GetUserItemsRequest(userId: userId, page: 1)
//        let userItemsTransformer = ItemEntityToCellViewModelTransform()
//        let viewModel = UserDetailVM(userRequest: userRequest, itemsRequest: userItemsRequest, userTransformer: userTransformer, itemTransformer: userItemsTransformer)
//        userDetailView.injectViewModel(viewModel: viewModel)
//        
//        userDetailView.selectedItem.subscribe(onNext: { [weak self] itemId in
//            self?.showItemDetail(itemId: itemId)
//        }).addDisposableTo(bag)
//        
//        userDetailView.selectedFollowTagList.subscribe(onNext: { [weak self] userId in
//            self?.showUserFollowTagList(userId: userId)
//        }).addDisposableTo(bag)
//        
//        userDetailView.selectedFollowee.subscribe(onNext: { [weak self] userId in
//            self?.showFolloweeList(userId: userId)
//        }).addDisposableTo(bag)
//        
//        userDetailView.selectedFollower.subscribe(onNext: { [weak self] userId in
//            self?.showFollowerList(userId: userId)
//        }).addDisposableTo(bag)
//
//        router.push(presentable: userDetailView, animated: true, completion: nil)
        
    }
    
}
