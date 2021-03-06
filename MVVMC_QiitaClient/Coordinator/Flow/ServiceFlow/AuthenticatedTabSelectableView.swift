//
//  TabSelectableView.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/19.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol AuthenticatedTabSelectableView: class {
    
    var itemTabNavigationController: UINavigationController { get }
    var tagTabNavigationController: UINavigationController { get }
    var myAccountNavigationController: UINavigationController { get }
    
    var selectedItemTabObservable: Observable<UINavigationController> { get }
    var selectedTagTabObservable: Observable<UINavigationController> { get }
    var selectedMyAccountTabObservable: Observable<UINavigationController> { get }
    
    func chnageSelectedTab(index: Int)
    
}
