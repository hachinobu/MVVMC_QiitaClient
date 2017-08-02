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
    
    var item: Driver<ItemViewModel> { get }
    
}
