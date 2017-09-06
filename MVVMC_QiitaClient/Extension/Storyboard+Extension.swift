//
//  Storyboard+Extension.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    static func instantiateViewController<T: UIViewController>(withType type: T.Type) -> T {
        let identifier = T.storyboardIdentifier
        return UIStoryboard(name: identifier, bundle: nil).instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
    }
    
    static func instantiateInitialViewController<T: UIViewController>(withType type: T.Type) -> T {
        let identifier = T.storyboardIdentifier
        return UIStoryboard(name: identifier, bundle: nil).instantiateInitialViewController() as! T
    }
    
}
