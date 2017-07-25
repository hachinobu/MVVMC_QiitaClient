//
//  UserEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserEntity {
    let description: String?
    let facebookId: String?
    let followeesCount: Int
    let followersCount: Int
    let githubLoginName: String?
    let id: String
    let itemsCount: Int
    let linkedinId: String?
    let location: String?
    let name: String?
    let organization: String?
    let permanentId: Int
    let profileImageUrlString: String
    let twitterScreenName: String?
    let websiteUrl: String?
}

extension UserEntity: ImmutableMappable {
    
    init(map: Map) throws {
        description = try? map.value("description")
        facebookId = try? map.value("facebook_id")
        followeesCount = try map.value("followees_count")
        followersCount = try map.value("followers_count")
        githubLoginName = try? map.value("github_login_name")
        id = try map.value("id")
        itemsCount = try map.value("items_count")
        linkedinId = try? map.value("linkedin_id")
        location = try? map.value("location")
        name = try? map.value("name")
        organization = try? map.value("organization")
        permanentId = try map.value("permanent_id")
        profileImageUrlString = try map.value("profile_image_url")
        twitterScreenName = try? map.value("twitter_screen_name")
        websiteUrl = try? map.value("website_url")
    }
    
}
