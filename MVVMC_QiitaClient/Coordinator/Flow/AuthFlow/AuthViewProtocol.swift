//
//  AuthViewProtocol.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AuthViewProtocol: class {
    
    var tappedAuth: Observable<Void> { get }
    var tappedSkipAuth: Observable<Void> { get }
    var onCompleteAuth: Observable<String> { get }
    
    func injectViewModel(viewModel: AuthViewModel)
    
}
