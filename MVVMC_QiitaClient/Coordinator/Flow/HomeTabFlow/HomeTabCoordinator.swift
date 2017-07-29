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
        let homeItemList = viewFactory.generateHomeItemListView()
        let request = QiitaAPI.GetItems()
        let transform = ItemEntityToCellViewModelTransform()
        let viewModel = HomeItemListVM(request: request, transformer: transform)
        homeItemList.injectViewModel(viewModel: viewModel)
        
        homeItemList.selectedItem.subscribe(onNext: { itemId in
            
        }).addDisposableTo(bag)
        
        homeItemList.selectedUser.subscribe(onNext: { userId in
            
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: homeItemList, hideBar: false)
        
    }
    
}
