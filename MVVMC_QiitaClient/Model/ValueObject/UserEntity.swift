//
//  UserEntity.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct UserEntity: Codable {
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
    
    private enum CodingKeys: String, CodingKey {
        case description
        case facebookId = "facebook_id"
        case followeesCount = "followees_count"
        case followersCount = "followers_count"
        case githubLoginName = "github_login_name"
        case id
        case itemsCount = "items_count"
        case linkedinId = "linkedin_id"
        case location
        case name
        case organization
        case permanentId = "permanent_id"
        case profileImageUrlString = "profile_image_url"
        case twitterScreenName = "twitter_screen_name"
        case websiteUrl = "website_url"
    }
    
}
