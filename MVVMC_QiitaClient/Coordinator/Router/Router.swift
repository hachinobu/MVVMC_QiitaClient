//
//  Router.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol Router {
    
    func setRoot(presentable: Presentable?, hideBar: Bool)
    func popToRoot(animated: Bool)
    func present(presentable: Presentable?, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func push(presentable: Presentable?, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
    
}
