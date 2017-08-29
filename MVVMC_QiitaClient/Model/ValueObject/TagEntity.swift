//
//  TagEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct TagEntity {
    let followersCount: Int
    let iconUrl: String?
    let id: String
    let itemsCount: Int
}

extension TagEntity: ImmutableMappable {
    
    init(map: Map) throws {
        followersCount = try map.value("followers_count")
        iconUrl = try? map.value("icon_url")
        id = try map.value("id")
        itemsCount = try map.value("items_count")
    }
    
}
