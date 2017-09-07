//
//  GroupEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct GroupEntity: Codable {
    let createdAt: String
    let id: Int
    let name: String
    let isPrivate: Bool
    let updatedAt: String
    let urlName: String
    
    private enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case id
        case name
        case isPrivate = "private"
        case updatedAt = "updated_at"
        case urlName = "url_name"
    }
    
}
