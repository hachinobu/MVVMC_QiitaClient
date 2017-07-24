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
        case notAuth
        case code(String)
        case authenticated(String)
        
        func fetchAccessToken() -> String? {
            switch self {
            case .authenticated(let token):
                return token
            case .none, .code(_), .notAuth:
                return nil
            }
        }
        
        func fetchCode() -> String? {
            switch self {
            case .code(let code):
                return code
            case .none, .notAuth, .authenticated(_):
                return nil
            }
        }
        
        func isAuthorized() -> Bool {
            switch self {
            case .none, .code(_):
                return false
            case .authenticated(_), .notAuth:
                return true
            }
        }
        
    }
    
}
