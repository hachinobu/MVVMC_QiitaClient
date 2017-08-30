//
//  TagListViewType.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/30.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol TagListViewType: class {
    
    var selectedTag: Observable<String> { get }
    
    func injectViewModel(viewModel: TagListViewModel)
    
}
