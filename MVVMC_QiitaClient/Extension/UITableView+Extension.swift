//
//  UITableView+Extension.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/28.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(type: T.Type) where T: ReusableView, T: NibLoadableView {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("wrong cell")
        }
        return cell
    }
    
}
