//
//  Coordinator.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    func start()
    func start(option: DeepLinkOption)
}
