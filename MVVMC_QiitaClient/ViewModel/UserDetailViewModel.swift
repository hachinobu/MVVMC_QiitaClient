//
//  UserDetailViewModel.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/18.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

protocol UserDetailViewModel: class {
    
    var userDetailItemPairs: Driver<(UserDetailTableCellViewModel, [ItemListTableCellViewModel])> { get }
    var error: Driver<ActionError> { get }
    var isLoadingIndicatorAnimation: Driver<Bool> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    
    func bindRefresh(refresh: Driver<Void>)
    func bindReachedBottom(reachedBottom: Driver<Void>)
    
}
