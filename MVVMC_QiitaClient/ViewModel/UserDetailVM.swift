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

final class UserDetailVM<UserResult, ItemsResult>: UserDetailViewModel {
    
    private let bag = DisposeBag()
    
    private let userDetailItemPairsObserver = PublishSubject<(UserDetailTableCellViewModel, [ItemListTableCellViewModel])>()
    lazy var userDetailItemPairs: Driver<(UserDetailTableCellViewModel, [ItemListTableCellViewModel])> =
        self.userDetailItemPairsObserver.asDriver(onErrorDriveWith: .empty())
    
    private let errorObserver = PublishSubject<ActionError>()
    lazy var error: Driver<ActionError> = self.errorObserver.asDriver(onErrorDriveWith: .empty())
    
    var isLoadingIndicatorAnimation: Driver<Bool> { get }
    lazy var viewDidLoadTrigger: PublishSubject<Void> = PublishSubject()
    
    init<UserRequest: QiitaRequest, ItemsRequest: PaginationRequest, Transform: Transformable>(
        userRequest: UserRequest,
        itemsRequest: ItemsRequest,
        transformer: Transform,
        session: Session = Session.shared
        ) where UserRequest.Response == UserResult, ItemsRequest.Response == ItemsResult,
        Transform.Input == (UserResult, ItemsResult),
        Transform.Output == (UserDetailTableCellViewModel, [ItemListTableCellViewModel]) {
            
            let userFetchAction: Action<Void, UserResult> = Action { _ in
                return session.rx.response(request: userRequest).shareReplayLatestWhileConnected()
            }
            
//            let itemsFetchAction: Action<Int, ItemsResult> = Action { page in
//                
//                var paginationRequest = request
//                paginationRequest.page = page
//                
//                return session.rx.response(request: paginationRequest)
//                    .map { $0.transform(transformable: transformer) }
//                    .shareReplayLatestWhileConnected()
//                
//            }
            
        
    }
    
}
