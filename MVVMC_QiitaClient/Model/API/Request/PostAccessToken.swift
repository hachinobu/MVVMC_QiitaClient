//
//  PostAccessToken.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit

struct PostAccessToken: QiitaRequest {
    
    typealias Response = AuthEntity
    
    private let clientId: String
    private let clientSecret: String
    private let code: String
    
    var headerField: [String : String] {
        return [:]
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var path: String {
        return "/api/v2/access_tokens"
    }
    
    var parameters: Any? {
        return ["client_id": clientId, "client_secret": clientSecret, "code": code]
    }
    
}
