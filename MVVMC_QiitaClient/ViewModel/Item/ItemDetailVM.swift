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
    
    private let hasLikeObserver = PublishSubject<Bool>()
    
    private let changeLikeStatusObserver = PublishSubject<Bool>()
    lazy var changeStatus: Driver<Bool> = self.changeLikeStatusObserver.asDriver(onErrorJustReturn: false)
    
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
                return session.rx.response(request: itemRequest).share()
            }
            
            let fetchStockCountAction: Action<Void, CountResult> = Action { _ in
                return session.rx.response(request: countRequest).share()
            }
            
            Observable.zip(fetchItemAction.elements, fetchStockCountAction.elements, hasLikeObserver) { transformer.transform(input: ($0, $1, $2)) }
                .bind(to: itemDetailObserver)
                .disposed(by: bag)
            
            fetchItemAction.errors
                .amb(fetchStockCountAction.errors)
                .bind(to: errorObserver)
                .disposed(by: bag)
            
            let fetchLikeStatusAction: Action<Void, Void> = Action { _ in
                return session.rx.response(request: getStatusRequest).share()
            }
            
            fetchLikeStatusAction.elements
                .map { _ in true }
                .bind(to: hasLikeObserver)
                .disposed(by: bag)
            
            fetchLikeStatusAction.errors
                .map { _ in false }
                .bind(to: hasLikeObserver)
                .disposed(by: bag)
            
            let putStatusAction: Action<Void, Void> = Action { _ in
                return session.rx.response(request: putStatusRequest).share()
            }
            putStatusAction.elements.map { _ in true }.bind(to: changeLikeStatusObserver).disposed(by: bag)
            putStatusAction.errors.map { _ in false }.bind(to: changeLikeStatusObserver).disposed(by: bag)
            
            let deleteStatusAction: Action<Void, Void> = Action { _ in
                return session.rx.response(request: deleteStatusRequest).share()
            }
            deleteStatusAction.elements.map { _ in false }.bind(to: changeLikeStatusObserver).disposed(by: bag)
            deleteStatusAction.errors.map { _ in true }.bind(to: changeLikeStatusObserver).disposed(by: bag)
            
            viewDidLoadTrigger.subscribe(onNext: { _ in
                fetchItemAction.execute(())
                fetchStockCountAction.execute(())
                fetchLikeStatusAction.execute(())
            }).disposed(by: bag)
            
            let likeStatusObservable = updateStatusTrigger.withLatestFrom(hasLikeObserver) { $1 }.share()
            likeStatusObservable.filter { $0 }.subscribe(onNext: { _ in
                deleteStatusAction.execute(())
            }).disposed(by: bag)
            
            likeStatusObservable.filter { !$0 }.subscribe(onNext: { _ in
                putStatusAction.execute(())
            }).disposed(by: bag)
        
            changeLikeStatusObserver.withLatestFrom(itemDetail) { (status, itemDetail) in
                itemDetail.updateLikeStatus(status: status)
            }.subscribe(onNext: { _ in
                //Noop
            }).disposed(by: bag)
            
    }
    
}
