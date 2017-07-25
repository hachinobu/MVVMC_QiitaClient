//
//  TabSelectableView.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/19.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol TabSelectableView: class {
    var selectedTimeLineTabObservable: Observable<UINavigationController> { get }
    var selectedMyAccountTabObservable: Observable<UINavigationController> { get }
}
