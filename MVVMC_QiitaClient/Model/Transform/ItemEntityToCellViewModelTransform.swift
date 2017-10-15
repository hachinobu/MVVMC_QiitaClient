//
//  ItemEntityToCellViewModelTransfom.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct ItemEntityToCellViewModelTransform: Transformable {
    
    typealias Input = ItemEntity
    typealias Output = ItemListTableCellViewModel
    
    func transform(input: ItemEntity) -> ItemListTableCellViewModel {
        
        let itemId = input.id
        let userId = input.user.id
        let profileURL = URL(string: input.user.profileImageUrlString)
        let userName = input.user.id
        let likeCount = input.likeCount.description + " いいね"
        let title = input.title
        let tag = input.tagList.map { $0.name }.joined(separator: ",")
        let viewModel = ItemListTableCellVM(itemId: itemId,
                                            userId: userId,
                                            profileURL: profileURL,
                                            userName: userName,
                                            likeCount: likeCount,
                                            title: title,
                                            tag: tag)
        
        return viewModel
        
    }
    
}
