//
//  HomeItemListVM.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import APIKit

final class HomeItemListVM<Results: Sequence>: ItemListViewModel {

    var items: Driver<[ItemListTableCellViewModel]> {
        
        self.fetchItemListAction.elements.withLatestFrom(self.fetchItemListAction.inputs) { $0.1 }.scan([ItemListTableCellVM]()) { (elements, page) -> [ItemListTableCellVM] in
            
        }
        
    }
    
    private let fetchItemListAction: Action<Int, [ItemListTableCellViewModel]>
    private var page = 0
    
    init<Request: PaginationRequest, Transform: Transformable>(
        request: Request,
        transformer: Transform,
        session: Session = Session.shared
        ) where Transform.Input == Results.Iterator.Element,
        Transform.Output == ItemListTableCellViewModel,
        Request.Response == Results {
        
        fetchItemListAction = Action { page in
            
            var paginationRequest = request
            paginationRequest.page = page
            
            return session.rx.response(request: paginationRequest)
                .map { $0.transform(transformable: transformer) }
                .shareReplayLatestWhileConnected()
            
        }
        
    }
    
}
