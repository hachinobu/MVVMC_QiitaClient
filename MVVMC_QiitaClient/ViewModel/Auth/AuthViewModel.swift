//
//  AuthViewModel.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import APIKit

protocol AuthViewModel: class {
    
    var accessToken: Driver<String> { get }
    var error: Driver<Error> { get }
    
    var fetchTokenTrigger: PublishSubject<Void> { get }
    
}
