//
//  NibLoadableView.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

protocol NibLoadableView: class {

}

extension NibLoadableView where Self: UIView {
    
    static var nibName: String {
        return String(describing: self)
    }
    
    static func loadView() -> Self {
        return UINib(nibName: nibName, bundle: nil)
            .instantiate(withOwner: self, options: nil).first as! Self
    }
    
}
