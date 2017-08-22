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

    private let FirstPage: Int = 1
    private let bag = DisposeBag()
    private let fetchItemListAction: Action<Int, [UserListTableCellViewModel]>
    private var currentPage = 1
    
    init<UsersRequest: PaginationRequest, Transform: Transformable>(
        request: UsersRequest,
        transformer: Transform,
        session: Session = Session.shared
        ) where Transform.Input == Results.Iterator.Element,
        Transform.Output == UserListTableCellViewModel, UsersRequest.Response == Results {
            
            let fetchUsersAction: Action<Int, [UserListTableCellViewModel]> = Action { page in
                
                var paginationRequest = request
                paginationRequest.page = page
                
                return session.rx.response(request: paginationRequest).map { $0.transform(transformable: transformer) }
            }
            
    }
    
}
