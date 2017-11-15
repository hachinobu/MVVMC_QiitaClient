//
//  DeepLinkOption.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/09/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

enum DeepLinkOption {
    case itemDetail(String)
    case tag(String)
    case user(String)
    case myAccount
    case likeUserList(String)
    case stockUserList(String)
    
    func isItem() -> Bool {
        switch self {
        case .itemDetail(_):
            return true
        default:
            return false
        }
    }

    func isTag() -> Bool {
        switch self {
        case .tag(_):
            return true
        default:
            return false
        }
    }
    
    func isMyAccount() -> Bool {
        switch self {
        case .myAccount:
            return true
        default:
            return false
        }
    }
    
    func isUser() -> Bool {
        switch self {
        case .user(_):
            return true
        default:
            return false
        }
    }
    
}
