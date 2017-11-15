//
//  ItemTabCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class ItemTabCoordinator: BaseCoordinator, ItemCoordinatorFinishFlowType, CoordinatorFinishFlowType {
    
    private let finishItemFlowObserver = PublishSubject<DeepLinkOption>()
    lazy var finishItemFlow: Observable<DeepLinkOption> = self.finishItemFlowObserver.asObservable()
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow = self.finishFlowObserver.asObservable()
    
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
        switch option {
        case .itemDetail(let id):
            showItemDetail(itemId: id)
        case .tag(let id):
            showTagItemList(tagId: id)
        default:
            return
        }
    }
    
    private func showAllItemList() {
        
        let itemListView = moduleFactory.generateAllItemListView()        
        itemListView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        itemListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.runUserFlow(option: .user(userId))
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: itemListView, hideBar: false)
        
    }
    
    private func showItemDetail(itemId: String) {
        
        let itemDetailView = moduleFactory.generateItemDetailView(itemId: itemId)
        itemDetailView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.runUserFlow(option: .user(userId))
        }).addDisposableTo(bag)
        
        itemDetailView.requiredAuth.subscribe(onNext: { [weak self] _ in
            AuthenticateQiita.sharedInstance.status.value = .loginFromItem
            self?.runAuthFlow(option: DeepLinkOption.itemDetail(itemId))
        }).addDisposableTo(bag)
        
        itemDetailView.selectedLikeCount.subscribe(onNext: { [weak self] itemId in
            self?.runUserFlow(option: .likeUserList(itemId))
        }).addDisposableTo(bag)
        
        itemDetailView.selectedStockCount.subscribe(onNext: { [weak self] itemId in
            self?.runUserFlow(option: .stockUserList(itemId))
        }).addDisposableTo(bag)
                
        router.push(presentable: itemDetailView, animated: true, completion: nil)
    }
    
    private func showTagItemList(tagId: String) {
        
        let itemListView = moduleFactory.generateTagItemListView(tagId: tagId)
        
        itemListView.selectedItem.subscribe(onNext: { [weak self] itemId in
            self?.showItemDetail(itemId: itemId)
        }).addDisposableTo(bag)
        
        itemListView.selectedUser.subscribe(onNext: { [weak self] userId in
            self?.runUserFlow(option: .user(userId))
        }).addDisposableTo(bag)
        
        itemListView.deinitView.bind(to: finishFlowObserver).addDisposableTo(bag)
        
        router.push(presentable: itemListView, animated: true, completion: nil)
        
    }
    
}

extension ItemTabCoordinator {
    
    private func runAuthFlow(option: DeepLinkOption) {
        
        let (module, coordinator) = coordinatorFactory.generateAuthCoordinatorBox()
        coordinator.finishFlow.do(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
        }).filter { AccessTokenStorage.hasAccessToken() && option.isItem() }
            .map { option }
            .bind(to: finishItemFlowObserver)
            .addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start()
        router.present(presentable: module, animated: true)
        
    }
    
    private func runTagFlow(option: DeepLinkOption) {
        
        guard let navigationController = router.toPresent() as? UINavigationController else {
            return
        }
        
        let (presentable, coordinator) = coordinatorFactory.generateTagCoordinatorBox(navigationController: navigationController)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        coordinator.start(option: option)
        router.push(presentable: presentable, animated: true, completion: nil)
        
    }
    
    private func runUserFlow(option: DeepLinkOption) {
        
        guard let navigationController = router.toPresent() as? UINavigationController else {
            return
        }
        
        let (presentable, coordinator) = coordinatorFactory.generateUserCoordinatorBox(navigationController: navigationController)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        
        coordinator.start(option: option)
        router.push(presentable: presentable, animated: true, completion: nil)
        
    }
    
}

