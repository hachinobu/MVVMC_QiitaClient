//
//  TagEntityToTagListTableCellVMTransform.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct TagEntityToTagListTableCellVMTransform: Transformable {
    
    func transform(input: TagEntity) -> TagListTableCellViewModel {
        
        let tagId = input.id
        let tagName = input.id
        var tagImageURL: URL? = nil
        if let iconURL = input.iconUrl {
            tagImageURL = URL(string: iconURL)
        }
        let tagCountInfo: String = "投稿数: \(input.itemsCount.description)  フォロワー数: \(input.followersCount.description)"
        return TagListTableCellVM(tagId: tagId, tagName: tagName, tagImageURL: tagImageURL, tagCountInfo: tagCountInfo)
        
    }
    
}
