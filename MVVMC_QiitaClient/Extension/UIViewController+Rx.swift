//
//  UIViewController+Rx.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/28.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    private func controlEvent(for selector: Selector) -> ControlEvent<Void> {
        return ControlEvent(events: sentMessage(selector).map { _ in })
    }
    
    var viewDidLoad: ControlEvent<Void> {
        return controlEvent(for: #selector(Base.viewDidLoad))
    }
    
    var viewWillAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(Base.viewWillAppear(_:)))
    }
    
    var viewDidAppear: ControlEvent<Void> {
        return controlEvent(for: #selector(Base.viewDidAppear(_:)))
    }
    
}
