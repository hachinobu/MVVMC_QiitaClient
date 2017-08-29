//
//  ItemEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct ItemEntity {
    let renderedBody: String
    let body: String
    let coediting: Bool
    let createdAt: String
    let group: GroupEntity?
    let id: String
    let isPrivate: Bool
    let tagList: [ItemTagEntity]
    let title: String
    let updatedAt: String
    let url: String
    let user: UserEntity
    
    struct ItemTagEntity: ImmutableMappable {
        let name: String
        let versions: [String]
        
        init(map: Map) throws {
            name = try map.value("name")
            versions = try map.value("versions")
        }
        
    }
    
}

extension ItemEntity: ImmutableMappable {
    
    init(map: Map) throws {
        renderedBody = try map.value("rendered_body")
        body = try map.value("body")
        coediting = try map.value("coediting")
        createdAt = try map.value("created_at")
        group = try? map.value("group")
        id = try map.value("id")
        isPrivate = try map.value("private")
        tagList = try map.value("tags")
        title = try map.value("title")
        updatedAt = try map.value("updated_at")
        url = try map.value("url")
        user = try map.value("user")
    }
    
}
