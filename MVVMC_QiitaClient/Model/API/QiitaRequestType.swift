//
//  QiitaRequestType.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit
import ObjectMapper

struct QiitaError: Error {
    let message: String
    
    init(object: AnyObject) {
        message = object["message"] as? String ?? "Unknown Error"
    }
}

protocol QiitaRequest: Request {
}

extension QiitaRequest {
    
    var headerField: [String: String] {
        guard let accessToken = AccessTokenStorage.fetchAccessToken() else {
            return [:]
        }
        return ["Authorization": "Bearer \(accessToken)"]
    }
    
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
    
    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        switch urlResponse.statusCode {
        case 200..<300:
            return object
        case 400, 401, 402, 403, 404:
            throw QiitaError(object: object as AnyObject)
        default:
            throw ResponseError.unacceptableStatusCode(urlResponse.statusCode)
        }
    }
    
}

extension QiitaRequest where Response: ImmutableMappable {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let json = object as? [String : Any] else {
            throw ResponseError.unexpectedObject(object)
        }
        return try Response(JSON: json)
    }
    
}

extension QiitaRequest where Response: Sequence, Response.Iterator.Element: ImmutableMappable {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let jsonArray = object as? [[String: Any]] else {
            throw ResponseError.unexpectedObject(object)
        }
        return try Mapper<Response.Iterator.Element>().mapArray(JSONArray: jsonArray) as! Response
    }
    
}

extension QiitaRequest where Response == Void {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Void {
        return ()
    }
    
}

