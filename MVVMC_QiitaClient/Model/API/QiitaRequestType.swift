//
//  QiitaRequestType.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit

struct QiitaError: Error {
    let message: String
    
    init(object: AnyObject) {
        message = object["message"] as? String ?? "Unknown Error"
    }
}

protocol QiitaRequest: Request {
}

extension QiitaRequest {
    
    var headerFields: [String: String] {
        guard let accessToken = AccessTokenStorage.fetchAccessToken() else {
            return [:]
        }
        return ["Authorization": "Bearer \(accessToken)"]
    }
    
    var baseURL: URL {
        return URL(string: "https://qiita.com")!
    }
    
    var dataParser: DataParser {
        return JSONDataParser(readingOptions: [])
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

extension QiitaRequest where Response: Codable {

    var dataParser: DataParser {
        return CodableParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }

}

extension QiitaRequest where Response: Codable, Response: Sequence, Response.Iterator.Element: Codable {

    var dataParser: DataParser {
        return CodableParser()
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }

}

extension QiitaRequest where Response == Void {
    
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Void {
        return ()
    }
    
}

class CodableParser: DataParser {
    // MARK: - DataParser
    
    /// Value for `Accept` header field of HTTP request.
    public var contentType: String? {
        return "application/json"
    }
    
    /// Return `Any` that expresses structure of JSON response.
    /// - Throws: `NSError` when `JSONSerialization` fails to deserialize `Data` into `Any`.
    public func parse(data: Data) throws -> Any {
        return data
    }
}
