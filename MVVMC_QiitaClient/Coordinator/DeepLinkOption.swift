//
//  DeepLinkOption.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/09/14.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

enum DeepLinkOption {
    case item(String)
    case tag(String)
    case myAccount
    
    func isItem() -> Bool {
        switch self {
        case .item(_):
            return true
        case .tag(_), .myAccount:
            return false
        }
    }

    func isTag() -> Bool {
        switch self {
        case .tag(_):
            return true
        case .item(_), .myAccount:
            return false
        }
    }
    
    func isMyAccount() -> Bool {
        switch self {
        case .myAccount:
            return true
        case .item(_), .tag(_):
            return false
        }
    }
    
    func linkId() -> String? {
        switch self {
        case .item(let itemId):
            return itemId
        case .tag(let tagId):
            return tagId
        case .myAccount:
            return nil
        }
    }
    
}
