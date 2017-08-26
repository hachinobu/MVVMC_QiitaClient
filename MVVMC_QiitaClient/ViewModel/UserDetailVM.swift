//
//  UserDetailVM.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/18.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit
import RxSwift
import RxCocoa
import Action

final class UserDetailVM<UserResult, ItemsResult: Sequence>: UserDetailViewModel {
    
    typealias UserDetailViewModel = UserDetailTableCellViewModel
    typealias ItemViewModel = ItemListTableCellViewModel
    
    private let bag = DisposeBag()
    private var currentPage: Int = 1
    
    private let userDetailItemPairsObserver = PublishSubject<(UserDetailViewModel, [ItemViewModel])>()
    lazy var userDetailItemPairs: Driver<(UserDetailViewModel, [ItemViewModel])> =
        self.userDetailItemPairsObserver.asDriver(onErrorDriveWith: .empty())
    
    private let errorObserver = PublishSubject<ActionError>()
    lazy var error: Driver<ActionError> = self.errorObserver.asDriver(onErrorDriveWith: .empty())
    
    private let isLoadingIndicatorAnimationObserver = PublishSubject<Bool>()
    lazy var isLoadingIndicatorAnimation: Driver<Bool> = self.isLoadingIndicatorAnimationObserver.asDriver(onErrorJustReturn: false)
    
    lazy var viewDidLoadTrigger: PublishSubject<Void> = PublishSubject()
    
    private let userFetchAction: Action<Void, UserDetailViewModel>
    private let itemFetchAction: Action<Int, [ItemViewModel]>
    
    init<UserRequest: QiitaRequest, ItemsRequest: PaginationRequest, UserTransform: Transformable, ItemTransform: Transformable>(
        userRequest: UserRequest,
        itemsRequest: ItemsRequest,
        userTransformer: UserTransform,
        itemTransformer: ItemTransform,
        session: Session = Session.shared
        ) where UserRequest.Response == UserResult, ItemsRequest.Response == ItemsResult,
        UserTransform.Input == UserResult, UserTransform.Output == UserDetailViewModel,
        ItemTransform.Input == ItemsResult.Iterator.Element, ItemTransform.Output == ItemViewModel {
            
            userFetchAction = Action { _ in
                return session.rx.response(request: userRequest).map { userTransformer.transform(input: $0) }
            }
            
            itemFetchAction = Action { page in
                var paginationRequest = itemsRequest
                paginationRequest.page = page
                return session.rx.response(request: paginationRequest).map { $0.transform(transformable: itemTransformer) }
            }
            
            let fetchItemElements = itemFetchAction.elements.withLatestFrom(itemFetchAction.inputs) { $0 }.scan([ItemViewModel]()) { (elements, result) in
                let page = result.1
                let fetchObjects = result.0
                if page == 1 {
                    self.currentPage = 1
                    return fetchObjects
                }
                
                if page > self.currentPage {
                    self.currentPage = page
                    return elements + fetchObjects
                }
                
                return elements
            }
            
            Observable.combineLatest(userFetchAction.elements, fetchItemElements)
                .bind(to: userDetailItemPairsObserver)
                .addDisposableTo(bag)
            
            Observable.amb([userFetchAction.errors, itemFetchAction.errors])
                .bind(to: errorObserver)
                .addDisposableTo(bag)
            
            viewDidLoadTrigger.subscribe(onNext: { [weak self] in
                self?.userFetchAction.execute()
                self?.itemFetchAction.execute(1)
            }).addDisposableTo(bag)
            
            Observable.combineLatest(userFetchAction.executing, itemFetchAction.executing)
                .map { $0.0 || $0.1 }
                .bind(to: isLoadingIndicatorAnimationObserver)
                .addDisposableTo(bag)
            
        
    }
    
    func bindRefresh(refresh: Driver<Void>) {
        
        refresh.asObservable()
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }.subscribe(onNext: { [weak self] _ in
                self?.userFetchAction.execute()
                self?.itemFetchAction.execute(1)
            }).addDisposableTo(bag)
        
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        
        reachedBottom.asObservable()
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .map { _ in self.currentPage + 1 }
            .bind(to: itemFetchAction.inputs)
            .addDisposableTo(bag)
        
    }
    
}



