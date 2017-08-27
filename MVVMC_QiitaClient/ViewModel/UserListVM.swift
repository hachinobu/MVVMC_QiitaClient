//
//  UserListVM.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/22.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Action
import APIKit

final class UserListVM<Results: Sequence>: UserListViewModel {

    private let bag = DisposeBag()
    private var currentPage = 1
    let fetchUsersAction: Action<Int, [UserListTableCellViewModel]>
    
    private let itemsObserver: PublishSubject<[UserListTableCellViewModel]> = PublishSubject()
    lazy var items: Driver<[UserListTableCellViewModel]> = self.itemsObserver.asDriver(onErrorJustReturn: [])
    
    private let errorObserver: PublishSubject<ActionError> = PublishSubject()
    lazy var error: Driver<ActionError> = self.errorObserver.asDriver(onErrorDriveWith: .empty())
    
    lazy var isLoadingIndicatorAnimation: Driver<Bool> = {
        self.fetchUsersAction.executing.shareReplayLatestWhileConnected().asDriver(onErrorJustReturn: false)
    }()
    
    private let completedAllData: PublishSubject<Bool> = PublishSubject()
    
    var viewDidLoadTrigger: PublishSubject<Void> = PublishSubject()
    
    init<UsersRequest: PaginationRequest, Transform: Transformable>(
        request: UsersRequest,
        transformer: Transform,
        session: Session = Session.shared
        ) where Transform.Input == Results.Iterator.Element,
        Transform.Output == UserListTableCellViewModel, UsersRequest.Response == Results {
            
            fetchUsersAction = Action { page in
                
                var paginationRequest = request
                paginationRequest.page = page
                
                return session.rx.response(request: paginationRequest).map { $0.transform(transformable: transformer) }
            }
            
            fetchUsersAction.elements
                .map { $0.count != request.perPage }
                .bind(to: completedAllData)
                .addDisposableTo(bag)
            
            let firstPage = 1
            
            fetchUsersAction.elements.withLatestFrom(self.fetchUsersAction.inputs) { $0 }
                .scan([UserListTableCellViewModel]()) { [weak self] elements, results in
                    
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
                    
                }.bind(to: self.itemsObserver)
                .addDisposableTo(bag)
            
            viewDidLoadTrigger.subscribe(onNext: { [weak self] _ in
                self?.fetchUsersAction.execute(1)
            }).addDisposableTo(bag)
            
            
    }
    
    func bindRefresh(refresh: Driver<Void>) {
        
        refresh.asObservable()
            .withLatestFrom(isLoadingIndicatorAnimation.asObservable())
            .filter { !$0 }.subscribe(onNext: { [weak self] _ in
                self?.fetchUsersAction.execute(1)
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
            .bind(to: fetchUsersAction.inputs)
            .addDisposableTo(bag)
        
    }
    
}
