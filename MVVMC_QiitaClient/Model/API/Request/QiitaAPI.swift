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
    
    struct GetItemsRequest: QiitaRequest, PaginationRequest {
        
        typealias Response = [ItemEntity]
        
        var page: Int
        let perPage: Int
        let query: String?
        
        init(page: Int = 1, perPage: Int = 20, query: String? = nil) {
            self.page = page
            self.perPage = perPage
            self.query = query
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/items"
        }
        
        var queryParameters: [String : Any]? {
            var parameter =  ["page": page.description, "per_page": perPage.description]
            if let query = query {
                parameter["query"] = query
            }
            return parameter
        }
        
    }

    struct GetItemDetailRequest: QiitaRequest {
        
        typealias Response = ItemEntity
        
        private let itemId: String
        
        init(itemId: String) {
            self.itemId = itemId
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/items/\(itemId)"
        }
        
    }
    
    struct GetItemStockersRequest: QiitaRequest {
        
        typealias Response = [UserEntity]
        
        private let itemId: String
        
        init(itemId: String) {
            self.itemId = itemId
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/items/\(itemId)/stockers"
        }
        
        var queryParameters: [String : Any]? {
            return ["per_page": 100]
        }
        
    }
    
    struct GetStockStatusRequest: QiitaRequest {
        
        typealias Response = Void
        
        private let itemId: String
        
        init(itemId: String) {
            self.itemId = itemId
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/items/\(itemId)/stock"
        }
        
    }
    
    struct PutStockStatusRequest: QiitaRequest {
        
        typealias Response = Void
        
        private let itemId: String
        
        init(itemId: String) {
            self.itemId = itemId
        }
        
        var method: HTTPMethod {
            return .put
        }
        
        var path: String {
            return "/api/v2/items/\(itemId)/stock"
        }
        
    }
    
    struct DeleteStockStatusRequest: QiitaRequest {
        
        typealias Response = Void
        
        private let itemId: String
        
        init(itemId: String) {
            self.itemId = itemId
        }
        
        var method: HTTPMethod {
            return .delete
        }
        
        var path: String {
            return "/api/v2/items/\(itemId)/stock"
        }
        
    }
    
    struct GetUserDetailRequest: QiitaRequest {
        
        typealias Response = UserEntity
        
        private let userId: String
        
        init(userId: String) {
            self.userId = userId
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/users/\(userId)"
        }
        
    }
    
    struct GetUserItemsRequest: QiitaRequest, PaginationRequest {
        
        typealias Response = [ItemEntity]
        
        private let userId: String
        var page: Int
        let perPage: Int
        
        init(userId: String, page: Int = 1, perPage: Int = 20) {
            self.userId = userId
            self.page = page
            self.perPage = perPage
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/users/\(userId)/items"
        }
        
        var queryParameters: [String : Any]? {
            return ["page": page, "per_page": perPage]
        }
        
    }
    
    struct GetFolloweesRequest: QiitaRequest, PaginationRequest {
        
        typealias Response = [UserEntity]
        
        private let userId: String
        var page: Int
        let perPage: Int
        
        init(userId: String, page: Int = 1, perPage: Int = 100) {
            self.userId = userId
            self.page = page
            self.perPage = perPage
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/users/\(userId)/followees"
        }
        
        var queryParameters: [String : Any]? {
            return ["page": page, "per_page": perPage]
        }
        
    }
    
    struct GetFollowersRequest: QiitaRequest, PaginationRequest {
        
        typealias Response = [UserEntity]
        
        private let userId: String
        var page: Int
        let perPage: Int
        
        init(userId: String, page: Int = 1, perPage: Int = 100) {
            self.userId = userId
            self.page = page
            self.perPage = perPage
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/users/\(userId)/followers"
        }
        
        var queryParameters: [String : Any]? {
            return ["page": page, "per_page": perPage]
        }
        
    }
    
    struct GetTagsRequest: QiitaRequest, PaginationRequest {
        
        enum Sort: String {
            case count
            case name
        }
        
        typealias Response = [TagEntity]
        
        var page: Int
        let perPage: Int
        let sort: Sort
        
        init(page: Int = 1, perPage: Int = 20, sort: Sort = .count) {
            self.page = page
            self.perPage = perPage
            self.sort = sort
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/tags"
        }
        
        var queryParameters: [String : Any]? {
            return ["page": page, "per_page": perPage, "sort": sort.rawValue]
        }
        
    }
    
    struct GetUserFollowTagsRequest: QiitaRequest, PaginationRequest {
        
        typealias Response = [TagEntity]
        
        let userId: String
        var page: Int
        let perPage: Int
        
        init(userId: String, page: Int = 1, perPage: Int = 20) {
            self.userId = userId
            self.page = page
            self.perPage = perPage
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/users/\(userId)/following_tags"
        }
        
        var queryParameters: [String : Any]? {
            return ["page": page, "per_page": perPage]
        }
        
    }
    
    struct GetTagItemsRequest: QiitaRequest, PaginationRequest {
        
        typealias Response = [ItemEntity]
        
        let tagId: String
        var page: Int
        let perPage: Int
        
        init(tagId: String, page: Int = 1, perPage: Int = 20) {
            self.tagId = tagId
            self.page = page
            self.perPage = perPage
        }
        
        var method: HTTPMethod {
            return .get
        }
        
        var path: String {
            return "/api/v2/tags/\(tagId)/items"
        }
        
        var queryParameters: [String : Any]? {
            return  ["page": page.description, "per_page": perPage.description]
        }
        
    }
    
}
