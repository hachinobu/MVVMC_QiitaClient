//
//  TagEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct TagEntity: Codable {
    let followersCount: Int
    let iconUrl: String?
    let id: String
    let itemsCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case followersCount = "followers_count"
        case iconUrl = "icon_url"
        case id
        case itemsCount = "items_count"
    }
    
}
