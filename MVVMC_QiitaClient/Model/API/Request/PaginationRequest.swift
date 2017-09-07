//
//  PaginationRequest.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit

protocol PaginationRequest: Request {
    var page: Int { get set }
    var perPage: Int { get }
}
