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

    lazy var items: Driver<[ItemListTableCellViewModel]> = {
        
        self.fetchItemListAction.elements
            .withLatestFrom(self.fetchItemListAction.inputs) { $0 }
            .scan([ItemListTableCellViewModel]()) { elements, results in
                
                let page = results.1
                if page == 0 {
                    self.currentPage = 0
                    return elements
                }
                
                if page > self.currentPage {
                    self.currentPage = page
                    return elements + results.0
                }
                
                return elements
            
            }.asDriver(onErrorJustReturn: [])
        
    }()
    
    lazy var error: Driver<Error> = {
        
        self.fetchItemListAction.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                default:
                    return Driver.empty()
                }
        }
        
    }()
    
    lazy var isLoadingIndicatorAnimation: Driver<Bool> = {
        self.fetchItemListAction.executing.shareReplayLatestWhileConnected().asDriver(onErrorJustReturn: false)
    }()
    
    private let bag = DisposeBag()
    private let fetchItemListAction: Action<Int, [ItemListTableCellViewModel]>
    private var currentPage = 0
    
    lazy var viewDidLoadTrigger: PublishSubject<Void> = PublishSubject<Void>()
    
    init<Request: PaginationRequest, Transform: Transformable>(
        request: Request,
        transformer: Transform,
        session: Session = Session.shared
        ) where Transform.Input == Results.Iterator.Element,
        Transform.Output == ItemListTableCellViewModel, Request.Response == Results {
            
            fetchItemListAction = Action { page in
                
                var paginationRequest = request
                paginationRequest.page = page
                
                return session.rx.response(request: paginationRequest)
                    .map { $0.transform(transformable: transformer) }
                    .shareReplayLatestWhileConnected()
                
            }
            
            viewDidLoadTrigger.asObservable()
                .take(1)
                .map { 0 }
                .bind(to: fetchItemListAction.inputs)
                .addDisposableTo(bag)
        
    }
    
    func bindRefresh(refresh: Driver<Void>) {
        refresh.asObservable()
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .map { _ in 0 }
            .bind(to: fetchItemListAction.inputs)
            .addDisposableTo(bag)
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        reachedBottom.asObservable()
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .map { _ in self.currentPage + 1 }
            .bind(to: fetchItemListAction.inputs)
            .addDisposableTo(bag)
    }
    
    
}
