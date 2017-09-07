//
//  ItemEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct ItemEntity: Codable {
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
    
    private enum CodingKeys: String, CodingKey {
        case renderedBody = "rendered_body"
        case body
        case coediting
        case createdAt = "created_at"
        case group
        case id
        case isPrivate = "private"
        case tagList = "tags"
        case title
        case updatedAt = "updated_at"
        case url
        case user
    }
    
    struct ItemTagEntity: Codable {
        let name: String
        let versions: [String]
        
        private enum CodingKeys: String, CodingKey {
            case name
            case versions
        }
        
    }
    
}
