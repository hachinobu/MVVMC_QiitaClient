//
//  ItemListVM.swift
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

final class ItemListVM<Results: Sequence>: ItemListViewModel {

    private let FirstPage: Int = 1
    
    lazy var items: Driver<[ItemListTableCellViewModel]> = {
        
        self.fetchItemListAction.elements
            .withLatestFrom(self.fetchItemListAction.inputs) { ($0, $1) }
            .scan([ItemListTableCellViewModel]()) { elements, results in
                
                let page = results.1
                let objects = results.0
                if page == self.FirstPage {
                    self.currentPage = self.FirstPage
                    return objects
                }
                
                if page > self.currentPage {
                    self.currentPage = page
                    return elements + objects
                }
                
                return elements
            
            }.asDriver(onErrorJustReturn: [])
        
    }()
    
    lazy var error: Driver<Error> = {
        
        self.fetchItemListAction.errors
            .asDriver(onErrorDriveWith: .empty())
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
        self.fetchItemListAction.executing.share().asDriver(onErrorJustReturn: false)
    }()
    
    private let bag = DisposeBag()
    private let fetchItemListAction: Action<Int, [ItemListTableCellViewModel]>
    private var currentPage = 1
    
    private let completedAllData: PublishSubject<Bool> = PublishSubject()
    
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
                    .share()
                
            }
            
            fetchItemListAction.elements
                .map { $0.count != request.perPage }
                .bind(to: completedAllData)
                .disposed(by: bag)
            
            viewDidLoadTrigger.asObservable()
                .take(1)
                .map { self.FirstPage }
                .bind(to: fetchItemListAction.inputs)
                .disposed(by: bag)
        
    }
    
    func bindRefresh(refresh: Driver<Void>) {
        refresh.asObservable()
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .map { _ in self.FirstPage }
            .bind(to: fetchItemListAction.inputs)
            .disposed(by: bag)
        
        refresh.asObservable()
            .map { false }
            .bind(to: completedAllData)
            .disposed(by: bag)
        
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        reachedBottom.asObservable()
            .withLatestFrom(completedAllData)
            .filter { !$0 }
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .map { _ in self.currentPage + 1 }
            .bind(to: fetchItemListAction.inputs)
            .disposed(by: bag)
    }
    
    
}
