//
//  TagListVM.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import APIKit
import RxSwift
import RxCocoa
import Action

final class TagListVM<Results: Sequence>: TagListViewModel {

    private let bag = DisposeBag()
    private var currentPage = 1

    private let fetchTagsAction: Action<Int, [TagListTableCellViewModel]>
    private let completedAllData: PublishSubject<Bool> = PublishSubject()
    
    private let tagsObserver: PublishSubject<[TagListTableCellViewModel]> = PublishSubject()
    lazy var tags: Driver<[TagListTableCellViewModel]> = self.tagsObserver.asDriver(onErrorJustReturn: [])
    
    private let errorObserver: PublishSubject<ActionError> = PublishSubject()
    lazy var error: Driver<ActionError> = self.errorObserver.asDriver(onErrorDriveWith: .empty())
    
    lazy var isLoadingIndicatorAnimation: Driver<Bool> = {
        self.fetchTagsAction.executing.asDriver(onErrorJustReturn: false)
    }()
    
    let viewDidLoadTrigger: PublishSubject<Void> = PublishSubject()
    
    init<TagsRequest: PaginationRequest, Transform: Transformable>
        (request: TagsRequest,
         transformer: Transform,
         session: Session = Session.shared) where Transform.Input == Results.Iterator.Element,
        Transform.Output == TagListTableCellViewModel, TagsRequest.Response == Results {
        
            fetchTagsAction = Action { page in
                
                var paginationRequest = request
                paginationRequest.page = page
                
                return session.rx.response(request: paginationRequest).map { $0.transform(transformable: transformer) }
                
            }
            
            fetchTagsAction.elements
                .map { $0.count != request.perPage }
                .bind(to: completedAllData)
                .addDisposableTo(bag)
            
            let firstPage = 1
            
            fetchTagsAction.elements.withLatestFrom(self.fetchTagsAction.inputs) { ($0, $1) }
                .scan([TagListTableCellViewModel]()) { [weak self] elements, results in
                    
                    guard let strongSelf = self else {
                        return elements
                    }
                    
                    let page = results.1
                    let objects = results.0
                    if page == firstPage {
                        strongSelf.currentPage = 1
                        return objects
                    }
                    
                    if page > strongSelf.currentPage {
                        strongSelf.currentPage = page
                        return elements + objects
                    }
                    
                    return elements
                    
                }.bind(to: self.tagsObserver)
                .addDisposableTo(bag)
            
            fetchTagsAction.errors
                .bind(to: errorObserver)
                .addDisposableTo(bag)
            
            viewDidLoadTrigger.subscribe(onNext: { [weak self] _ in
                self?.fetchTagsAction.execute(1)
            }).addDisposableTo(bag)
            
    }
    
    
    func bindRefresh(refresh: Driver<Void>) {
        
        refresh.asObservable()
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }.subscribe(onNext: { [weak self] _ in
                self?.fetchTagsAction.execute(1)
            }).addDisposableTo(bag)
        
        refresh.asObservable()
            .map { false }
            .bind(to: completedAllData)
            .addDisposableTo(bag)
        
    }
    
    func bindReachedBottom(reachedBottom: Driver<Void>) {
        
        reachedBottom.asObservable()
            .withLatestFrom(completedAllData)
            .filter { !$0 }
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }
            .map { _ in self.currentPage + 1 }
            .bind(to: fetchTagsAction.inputs)
            .addDisposableTo(bag)
        
    }
    
}
