//
//  QiitaAPI.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit

final class QiitaAPI {
    
    init() {
    }
    
    // Get Qiita AccessToken
    struct PostAccessTokenRequest: QiitaRequest, AuthRequest {
        
        typealias Response = AuthEntity
        
        private let clientId: String
        private let clientSecret: String
        var code: String
        
        init(clientId: String, clientSecret: String, code: String = "") {
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.code = code
        }
        
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
            return ["client_id" : clientId, "client_secret" : clientSecret, "code" : code]
        }
        
    }
    
    struct GetItems: QiitaRequest, PaginationRequest {
        
        typealias Response = [ItemEntity]
        
        var page: Int = 0
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/items"
        }
        
        var parameters: Any? {
            return ["page": page.description]
        }
        
    }

    
}
