//
//  UserCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/11/07.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class UserCoordinator: BaseCoordinator, CoordinatorFinishFlowType {
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow = self.finishFlowObserver.asObservable()
    
    private let bag = DisposeBag()
    private let moduleFactory: UserModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(moduleFactory: UserModuleFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showMyAccountView()
    }
    
    override func start(option: DeepLinkOption) {
        
        switch option {
        case .myAccount:
            start()
        case .user(let id):
            showUserDetail(userId: id)
        case .likeUserList(let id):
            showLikeUserList(itemId: id)
        case .stockUserList(let id):
            showStockUserList(itemId: id)
        default:
            return
        }
        
    }
    
    private func showMyAccountView() {
        
        let myAccountView = moduleFactory.generateMyAccountView()
        
        myAccountView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.runItemFlow(option: .itemDetail(itemId))
        }).disposed(by: bag)
        
        myAccountView.selectedFollowTagList.subscribe(onNext: { [weak self] userId in
            self?.runTagFlow(option: .user(userId))
        }).disposed(by: bag)
        
        myAccountView.selectedFollowee.subscribe(onNext: { [weak self] userId in
            self?.showFolloweeList(userId: userId)
        }).disposed(by: bag)
        
        myAccountView.selectedFollower.subscribe(onNext: { [weak self] userId in
            self?.showFollowerList(userId: userId)
        }).disposed(by: bag)
        
        myAccountView.logoutAction.do(onNext: { _ in
            AuthenticateQiita.sharedInstance.status.value = .none
        }).map { AccessTokenStorage.deleteAccessToken() }
            .filter { $0 }
            .map { _ in }
            .bind(to: finishFlowObserver)
            .disposed(by: bag)
        
        router.setRoot(presentable: myAccountView, hideBar: false)
        
    }
    
    private func showUserDetail(userId: String) {
        
        let userDetailView = moduleFactory.generateUserDetailView(userId: userId)
        
        userDetailView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.runItemFlow(option: .itemDetail(itemId))
        }).disposed(by: bag)
        
        userDetailView.selectedFollowTagList.subscribe(onNext: { [weak self] userId in
            self?.runTagFlow(option: .user(userId))
        }).disposed(by: bag)
        
        userDetailView.selectedFollowee.subscribe(onNext: { [weak self] userId in
            self?.showFolloweeList(userId: userId)
        }).disposed(by: bag)
        
        userDetailView.selectedFollower.subscribe(onNext: { [weak self] userId in
            self?.showFollowerList(userId: userId)
        }).disposed(by: bag)
        
        userDetailView.deinitView.bind(to: finishFlowObserver).disposed(by: bag)
        
        router.push(presentable: userDetailView, animated: true, completion: nil)
        
    }
    
    private func showFolloweeList(userId: String) {
        
        let userListView = moduleFactory.generateFolloweeUserListView(userId: userId)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).disposed(by: bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
    
    private func showFollowerList(userId: String) {
        
        let userListView = moduleFactory.generateFollowerUserListView(userId: userId)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).disposed(by: bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
    
    private func showLikeUserList(itemId: String) {
        
        let userListView = moduleFactory.generateLikeUserListView(itemId: itemId)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).disposed(by: bag)
        
        userListView.deinitView.bind(to: finishFlowObserver).disposed(by: bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
    
    private func showStockUserList(itemId: String) {
        
        let userListView = moduleFactory.generateStockUserListView(itemId: itemId)
        
        userListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.showUserDetail(userId: userId)
        }).disposed(by: bag)
        
        userListView.deinitView.bind(to: finishFlowObserver).disposed(by: bag)
        
        router.push(presentable: userListView, animated: true, completion: nil)
        
    }
        
}

extension UserCoordinator {
    
    private func runItemFlow(option: DeepLinkOption) {
        
        guard let navigationController = router.toPresent() as? UINavigationController else {
            return
        }
        
        let (presentable, coordinator) = coordinatorFactory.generateItemCoordinatorBox(navigationController: navigationController)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
        }).disposed(by: bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start(option: option)
        router.push(presentable: presentable, animated: true, completion: nil)
        
    }
    
    private func runTagFlow(option: DeepLinkOption) {
        
        guard let navigationController = router.toPresent() as? UINavigationController else {
            return
        }
        
        let (presentable, coordinator) = coordinatorFactory.generateTagCoordinatorBox(navigationController: navigationController)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
        }).disposed(by: bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start(option: option)
        router.push(presentable: presentable, animated: true, completion: nil)
        
    }
    
}
