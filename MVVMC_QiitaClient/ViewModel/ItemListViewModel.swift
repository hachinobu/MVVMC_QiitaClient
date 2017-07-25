//
//  ItemListViewModel.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ItemListViewModel: class {
    
    var items: Driver<[ItemListTableCellViewModel]> { get }
    var error: Driver<Error> { get }
    var isLoadingIndicatorAnimation: Driver<Bool> { get }
    
    func bindRefresh(refresh: Driver<Void>)
    func bindReachedBottom(reachedBottom: Driver<Void>)
    
}
