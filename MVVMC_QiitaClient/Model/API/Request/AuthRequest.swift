//
//  AuthRequest.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit

protocol AuthRequest: Request {
    associatedtype Response: AccessTokenProtocol
    var code: String { get set }
}
