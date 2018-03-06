//
//  URLRequest+Extension.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2018/03/06.
//  Copyright © 2018年 hachinobu. All rights reserved.
//

import Foundation

extension URLRequest {
    
    var curlString: String {
        #if !DEBUG
            return ""
        #else
            var result = "curl -k"
            
            if let method = httpMethod {
                result += "-X \(method) \\\n"
            }
            
            if let headers = allHTTPHeaderFields {
                headers.forEach { result += "-H \"\($0.key): \($0.value)\" \\\n" }
            }
            
            if let body = httpBody, !body.isEmpty, let string = String(data: body, encoding: .utf8), !string.isEmpty {
                result += "-d '\(string)' \\\n"
            }
            
            if let url = url {
                result += url.absoluteString
            }
            
            return result
        #endif
    }
    
}
