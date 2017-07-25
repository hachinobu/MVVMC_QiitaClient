//
//  AppDelegate+Auth.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        fetchAuthoriedCode(url: url)
        return true
    }
    
    private func fetchAuthoriedCode(url: URL) {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let scheme = urlComponents?.scheme, scheme.hasPrefix(AuthInfo.redirectUrlScheme),
            let queryItems = urlComponents?.queryItems else { return }
        
        let query = queryItems.reduce([String : String]()) { (result, item) in
            var queryInfo = result
            let value = item.value ?? ""
            queryInfo[item.name] = value
            return queryInfo
        }
        
        guard let code = query["code"], let state = query["state"],
            state == AuthInfo.accessTokenState else { return }
        
        AuthenticateQiita.sharedInstance.status.value = .code(code)
        
    }
    
}
