//
//  ReusableViewController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol ReusableViewController: class {}

extension ReusableViewController where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
}

extension UIViewController: ReusableViewController {}
