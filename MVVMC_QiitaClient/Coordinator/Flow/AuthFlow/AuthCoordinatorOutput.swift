//
//  AuthCoordinatorOutput.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthCoordinatorOutput: class {
    var finishFlow: Observable<Void> { get }
}
