//
//  UserDetailViewType.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol UserDetailViewType: class {
    var selectedItem: Observable<String> { get }
    var selectedFollower: Observable<String> { get }
    var selectedFollowee: Observable<String> { get }
    var selectedFollowTagList: Observable<String> { get }
    var isDisplayButton: Bool { get }
    var logoutAction: Observable<Void> { get }
    
    func injectViewModel(viewModel: UserDetailViewModel)
}
