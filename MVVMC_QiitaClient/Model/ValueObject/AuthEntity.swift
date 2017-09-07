//
//  AuthEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct AuthEntity: Codable {
    let cliendId: String
    let scopes: [String]
    let token: String
    
    private enum CodingKeys: String, CodingKey {
        case cliendId = "client_id"
        case scopes
        case token
    }
    
}

extension AuthEntity: AccessTokenProtocol {
    
    func fetchAccessToken() -> String {
        return token
    }
    
}
