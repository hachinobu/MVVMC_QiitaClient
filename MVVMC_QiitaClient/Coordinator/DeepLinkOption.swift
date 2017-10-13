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
    
    func hasItemId() -> Bool {
        switch self {
        case .item(_):
            return true
        case .tag(_), .myAccount:
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
