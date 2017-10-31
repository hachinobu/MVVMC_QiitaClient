//
//  AuthenticateQiita.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class AuthenticateQiita {
    
    static let sharedInstance: AuthenticateQiita = AuthenticateQiita()
    let status = Variable<AuthStatus>(.none)
    
}

extension AuthenticateQiita {
    
    enum AuthStatus {
        
        case none
        case skip
        case loginFromItem
        case loginFromAccount
        case code(String)
        case authenticated(String)
        
        func fetchAccessToken() -> String? {
            guard case let .authenticated(token) = self else {
                return nil
            }
            return token
        }
        
        func fetchCode() -> String? {
            guard case let .code(code) = self else {
                return nil
            }
            return code
        }
        
        func isAuthorized() -> Bool {
            switch self {
            case .none, .code(_):
                return false
            case .authenticated(_), .skip, .loginFromItem, .loginFromAccount:
                return true
            }
        }
        
        func isSkip() -> Bool {
            guard case .skip = self else {
                return false
            }
            return true
        }
        
        func isLoginFromItem() -> Bool {
            guard case .loginFromItem = self else {
                return false
            }
            return true
        }
        
        func isLoginFromSignIn() -> Bool {
            guard case .loginFromAccount = self else {
                return false
            }
            return true
        }
        
    }
    
}
