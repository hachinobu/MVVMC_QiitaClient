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
        
        itemListView.selectedUser.subscribe(onNext: { userId in
            
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
        
        itemDetailView.selectedUser.subscribe(onNext: { userId in
            print(userId)
        }).addDisposableTo(bag)
        
        router.push(presentable: itemDetailView, animated: true, completion: nil)
        
    }
    
}
