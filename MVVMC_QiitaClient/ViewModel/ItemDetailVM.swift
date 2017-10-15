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
    
    private let hasStockObserver = PublishSubject<Bool>()
    
    private let changeStockStatusObserver = PublishSubject<Bool>()
    lazy var changeStatus: Driver<Bool> = self.changeStockStatusObserver.asDriver(onErrorJustReturn: false)
    
    lazy var viewDidLoadTrigger: PublishSubject<Void> = PublishSubject()
    lazy var updateStatusTrigger: PublishSubject<Void> = PublishSubject()
    
    init<ItemRequest: QiitaRequest, CountRequest: QiitaRequest, Transform: Transformable,
        GetStatusRequest: QiitaRequest, PutStatusRequest: QiitaRequest, DeleteStatusRequest: QiitaRequest>(
        itemRequest: ItemRequest,
        countRequest: CountRequest,
        transformer: Transform,
        getStatusRequest: GetStatusRequest,
        putStatusRequest: PutStatusRequest,
        deleteStatusRequest: DeleteStatusRequest,
        session: Session = Session.shared) where ItemRequest.Response == ItemResult, CountRequest.Response == CountResult,
        Transform.Input == (ItemResult, CountResult, Bool), Transform.Output == ItemViewModel,
        GetStatusRequest.Response == Void, PutStatusRequest.Response == Void, DeleteStatusRequest.Response == Void {
            
            let fetchItemAction: Action<Void, ItemResult> = Action { _ in
                return session.rx.response(request: itemRequest).shareReplayLatestWhileConnected()
            }
            
            let fetchStockCountAction: Action<Void, CountResult> = Action { _ in
                return session.rx.response(request: countRequest).shareReplayLatestWhileConnected()
            }
            
            Observable.zip(fetchItemAction.elements, fetchStockCountAction.elements, hasStockObserver) { transformer.transform(input: ($0, $1, $2)) }
                .bind(to: itemDetailObserver)
                .addDisposableTo(bag)
            
            fetchItemAction.errors
                .amb(fetchStockCountAction.errors)
                .bind(to: errorObserver)
                .addDisposableTo(bag)
            
            let fetchStockStatusAction: Action<Void, Void> = Action { _ in
                return session.rx.response(request: getStatusRequest).shareReplayLatestWhileConnected()
            }
            
            fetchStockStatusAction.elements
                .map { _ in true }
                .bind(to: hasStockObserver)
                .addDisposableTo(bag)
            
            fetchStockStatusAction.errors
                .map { _ in false }
                .bind(to: hasStockObserver)
                .addDisposableTo(bag)
            
            let putStatusAction: Action<Void, Void> = Action { _ in
                return session.rx.response(request: putStatusRequest).shareReplayLatestWhileConnected()
            }
            putStatusAction.elements.map { _ in true }.bind(to: changeStockStatusObserver).addDisposableTo(bag)
            putStatusAction.errors.map { _ in false }.bind(to: changeStockStatusObserver).addDisposableTo(bag)
            
            let deleteStatusAction: Action<Void, Void> = Action { _ in
                return session.rx.response(request: deleteStatusRequest).shareReplayLatestWhileConnected()
            }
            deleteStatusAction.elements.map { _ in false }.bind(to: changeStockStatusObserver).addDisposableTo(bag)
            deleteStatusAction.errors.map { _ in true }.bind(to: changeStockStatusObserver).addDisposableTo(bag)
            
            viewDidLoadTrigger.subscribe(onNext: { _ in
                fetchItemAction.execute(())
                fetchStockCountAction.execute(())
                fetchStockStatusAction.execute(())
            }).addDisposableTo(bag)
            
            let stockStatusObservable = updateStatusTrigger.withLatestFrom(hasStockObserver) { $1 }.shareReplayLatestWhileConnected()
            stockStatusObservable.filter { $0 }.subscribe(onNext: { _ in
                deleteStatusAction.execute(())
            }).addDisposableTo(bag)
            
            stockStatusObservable.filter { !$0 }.subscribe(onNext: { _ in
                putStatusAction.execute(())
            }).addDisposableTo(bag)
        
            changeStockStatusObserver.withLatestFrom(itemDetail) { (status, itemDetail) in
                itemDetail.updateStockStatus(status: status)
            }.subscribe(onNext: { _ in
                //Noop
            }).addDisposableTo(bag)
            
    }
    
}
