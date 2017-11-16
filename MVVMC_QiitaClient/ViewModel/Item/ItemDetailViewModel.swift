//
//  ItemDetailViewModel.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/02.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action

protocol ItemDetailViewModel: class {
    
    var itemDetail: Driver<ItemViewModel> { get }
    var error: Driver<ActionError> { get }
    var changeStatus: Driver<Bool> { get }
    
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var updateStatusTrigger: PublishSubject<Void> { get }
    
}
