//
//  ItemListViewType.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/28.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol ItemListViewType {
    var selectedItem: Observable<String> { get }
    var selectedUser: Observable<String> { get }
    var deinitView: Observable<Void> { get }
    
    func injectViewModel(viewModel: ItemListViewModel)
}
