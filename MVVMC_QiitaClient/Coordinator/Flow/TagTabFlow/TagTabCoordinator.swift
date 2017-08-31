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
    
    private let bag = DisposeBag()
    private let viewFactory: TagTabViewFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(viewFactory: TagTabViewFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.viewFactory = viewFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showAllTagListView()
    }
    
    private func showAllTagListView() {
        
        let tagListView = viewFactory.generateTagListView()
        let tagsRequest = QiitaAPI.GetTagsRequest(page: 1, perPage: 20, sort: .count)
        let transformer = TagEntityToTagListTableCellVMTransform()
        let viewModel = TagListVM(request: tagsRequest, transformer: transformer)
        tagListView.injectViewModel(viewModel: viewModel)
        
        tagListView.selectedTagId.subscribe(onNext: { [weak self] tagId in
            print(tagId)
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: tagListView, hideBar: false)
        
    }
    
}
