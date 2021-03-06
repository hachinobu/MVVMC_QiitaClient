//
//  AuthenticationType.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AuthenticationType: class {
    
    var tappedAuth: Observable<Void> { get }
    var tappedSkipAuth: Observable<Void> { get }
    var onCompleteAuth: Observable<String> { get }
    var closeButtonTapped: Observable<Void> { get }
    
    var skipButtonHidden: Bool { set get }
    
    func injectViewModel(viewModel: AuthViewModel)
    
}
