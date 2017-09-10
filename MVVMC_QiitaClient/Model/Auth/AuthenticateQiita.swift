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
        case skipAuth
        case code(String)
        case authenticated(String)
        
        func fetchAccessToken() -> String? {
            switch self {
            case .authenticated(let token):
                return token
            case .none, .code(_), .skipAuth:
                return nil
            }
        }
        
        func fetchCode() -> String? {
            switch self {
            case .code(let code):
                return code
            case .none, .skipAuth, .authenticated(_):
                return nil
            }
        }
        
        func isAuthorized() -> Bool {
            switch self {
            case .none, .code(_):
                return false
            case .authenticated(_), .skipAuth:
                return true
            }
        }
        
        func isSkipAuth() -> Bool {
            switch self {
            case .skipAuth:
                return true
            default:
                return false
            }
        }
        
    }
    
}
