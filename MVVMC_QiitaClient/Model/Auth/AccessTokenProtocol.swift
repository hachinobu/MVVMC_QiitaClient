//
//  AccessTokenProtocol.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol AccessTokenProtocol {
    func fetchAccessToken() -> String
}
