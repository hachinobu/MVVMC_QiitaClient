//
//  Presentable.swift
//  MVVMC-QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
    
}
