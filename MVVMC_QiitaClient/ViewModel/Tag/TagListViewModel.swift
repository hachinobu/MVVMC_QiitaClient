//
//  TagListViewModel.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

protocol TagListViewModel: class {
    
    var tags: Driver<[TagListTableCellViewModel]> { get }
    var error: Driver<ActionError> { get }
    var isLoadingIndicatorAnimation: Driver<Bool> { get }
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    
    func bindRefresh(refresh: Driver<Void>)
    func bindReachedBottom(reachedBottom: Driver<Void>)
    
}
