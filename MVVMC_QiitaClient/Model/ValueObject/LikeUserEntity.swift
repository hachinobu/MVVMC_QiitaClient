//
//  LikeUserEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/10/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct LikeUserEntity: Codable {
    
    let createdAt: String
    let user: UserEntity
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case user
    }
    
}
