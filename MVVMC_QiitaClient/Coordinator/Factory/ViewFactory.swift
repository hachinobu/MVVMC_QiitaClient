//
//  ViewFactory.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

final class ViewFactory: AuthViewFactory {
    
    func generateAuthView() -> AuthViewProtocol & Presentable {
        let authView = UIStoryboard.instantiateInitialViewController(withType: AuthViewController.self)
        return authView
    }
    
}
