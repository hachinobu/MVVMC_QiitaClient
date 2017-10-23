//
//  AccessTokenStorage.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct AccessTokenStorage {
    
    private static let tokenKey = "AccessTokenKey"
    
    static func fetchAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    static func deleteAccessToken() -> Bool {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        return UserDefaults.standard.synchronize()
    }
    
    static func saveAccessToken(token: String) -> Bool {
        UserDefaults.standard.set(token, forKey: tokenKey)
        return UserDefaults.standard.synchronize()
    }
    
    static func hasAccessToken() -> Bool {
        return UserDefaults.standard.string(forKey: tokenKey) != nil
    }
    
}
