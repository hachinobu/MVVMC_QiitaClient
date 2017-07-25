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
    let name: String
    let versions: [String]
}

extension TagEntity: ImmutableMappable {
    
    init(map: Map) throws {
        name = try map.value("name")
        versions = try map.value("versions")
    }
    
}
