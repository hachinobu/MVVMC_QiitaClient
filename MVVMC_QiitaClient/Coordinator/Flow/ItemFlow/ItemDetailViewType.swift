//
//  ItemDetailViewType.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol ItemDetailViewType: class {
    
    var selectedUser: Observable<String> { get }
    var requiredAuth: Observable<Void> { get }
    
    func injectViewModel(viewModel: ItemDetailViewModel)
    
}
