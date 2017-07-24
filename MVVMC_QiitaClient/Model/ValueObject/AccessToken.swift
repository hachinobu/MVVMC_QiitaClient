//
//  AccessToken.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct AccessToken {
    let cliendId: String
    let scopes: [String]
    let token: String
}

extension AccessToken: ImmutableMappable {
    
    init(map: Map) throws {
        cliendId = try map.value("client_id")
        scopes = try map.value("scopes")
        token = try map.value("token")
    }
    
}
