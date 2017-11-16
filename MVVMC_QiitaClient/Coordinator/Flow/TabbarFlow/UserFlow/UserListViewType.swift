//
//  UserListViewType.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol UserListViewType: class {
    
    var selectedUser: Observable<String> { get }
    var deinitView: Observable<Void> { get }
    
    func injectViewModel(viewModel: UserListViewModel)
    
}
