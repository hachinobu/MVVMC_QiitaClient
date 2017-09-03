//
//  NoAuthTabSelectable.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol NoAuthTabSelectable: class {
    var selectedItemTabObservable: Observable<UINavigationController> { get }
    var selectedTagTabObservable: Observable<UINavigationController> { get }
}
