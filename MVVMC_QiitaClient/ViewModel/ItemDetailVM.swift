//
//  ItemDetailVM.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import APIKit

final class ItemDetailVM<ItemResult, CountResult>: ItemDetailViewModel {
    
    private let bag = DisposeBag()
    
    private let itemDetailObserver = PublishSubject<ItemViewModel>()
    lazy var itemDetail: Driver<ItemViewModel> = self.itemDetailObserver.asDriver(onErrorDriveWith: .empty())
    
    private let errorObserver = PublishSubject<ActionError>()
    lazy var error: Driver<ActionError> = self.errorObserver.asDriver(onErrorDriveWith: .empty())
    
    lazy var viewDidLoadTrigger: PublishSubject<Void> = PublishSubject()
    
    init<ItemRequest: QiitaRequest, CountRequest: QiitaRequest, Transform: Transformable>(
        itemRequest: ItemRequest,
        countRequest: CountRequest,
        transformer: Transform,
        session: Session = Session.shared) where ItemRequest.Response == ItemResult, CountRequest.Response == CountResult,
        Transform.Input == (ItemResult, CountResult), Transform.Output == ItemViewModel {
            
            let fetchItemAction: Action<Void, ItemResult> = Action { _ in
                return session.rx.response(request: itemRequest).shareReplayLatestWhileConnected()
            }
            
            let fetchStockCountAction: Action<Void, CountResult> = Action { _ in
                return session.rx.response(request: countRequest).shareReplayLatestWhileConnected()
            }
            
            Observable.zip(fetchItemAction.elements, fetchStockCountAction.elements) { transformer.transform(input: $0) }
                .bind(to: itemDetailObserver)
                .addDisposableTo(bag)
            
            fetchItemAction.errors
                .amb(fetchStockCountAction.errors)
                .bind(to: errorObserver)
                .addDisposableTo(bag)
            
            viewDidLoadTrigger.subscribe(onNext: { _ in
                fetchItemAction.execute(())
                fetchStockCountAction.execute(())
            }).addDisposableTo(bag)
        
    }
    
}
