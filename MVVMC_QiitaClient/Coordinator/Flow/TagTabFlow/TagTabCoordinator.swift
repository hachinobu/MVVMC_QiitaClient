//
//  TagTabCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/31.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class TagTabCoordinator: BaseCoordinator, CoordinatorFinishFlowType {
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow = self.finishFlowObserver.asObservable()
    
    private let bag = DisposeBag()
    private let moduleFactory: TagModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(moduleFactory: TagModuleFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showAllTagListView()
    }
    
    override func start(option: DeepLinkOption) {
        switch option {
        case .tag(_):
            runItemFlow(option: option)
        case .user(let id):
            showUserFollowTagList(userId: id)
        default:
            return
        }
    }
    
    private func showAllTagListView() {
        
        let tagListView = moduleFactory.generateAllTagListView()
        
        tagListView.selectedTagId.subscribe(onNext: { [weak self] tagId in
            self?.runItemFlow(option: .tag(tagId))
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: tagListView, hideBar: false)
        
    }

    private func showUserFollowTagList(userId: String) {

        let tagListView = moduleFactory.generateUserFollowTagListView(userId: userId)

        tagListView.selectedTagId.subscribe(onNext: { [weak self] tagId in
            self?.runItemFlow(option: .tag(tagId))
        }).addDisposableTo(bag)

        tagListView.deinitView.bind(to: finishFlowObserver).addDisposableTo(bag)

        router.push(presentable: tagListView, animated: true, completion: nil)

    }
    
}

extension TagTabCoordinator {
    
    private func runItemFlow(option: DeepLinkOption) {
        
        guard let navigationController = router.toPresent() as? UINavigationController else {
            return
        }
        
        let (presentable, coordinator) = coordinatorFactory.generateItemCoordinatorBox(navigationController: navigationController)
        coordinator.finishFlow.subscribe(onNext: { [weak self, weak coordinator] _ in
            self?.removeDependency(coordinator: coordinator)
        }).addDisposableTo(bag)
        
        addDependency(coordinator: coordinator)
        
        coordinator.start(option: option)
        router.push(presentable: presentable, animated: true, completion: nil)
        
    }
    
}


