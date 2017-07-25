//
//  GroupEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct GroupEntity {
    let createdAt: String
    let id: Int
    let name: String
    let isPrivate: Bool
    let updatedAt: String
    let urlName: String
}

extension GroupEntity: ImmutableMappable {
    
    init(map: Map) throws {
        createdAt = try map.value("created_at")
        id = try map.value("id")
        name = try map.value("name")
        isPrivate = try map.value("private")
        updatedAt = try map.value("updated_at")
        urlName = try map.value("url_name")
    }
    
}
