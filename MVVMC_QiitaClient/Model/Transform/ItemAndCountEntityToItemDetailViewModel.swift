//
//  ItemAndCountEntityToItemDetailViewModel.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct ItemAndCountEntityToItemDetailViewModel: Transformable {
    
    func transform(input: (ItemEntity, [UserEntity], Bool)) -> ItemViewModel {
        
        let input: (item: ItemEntity, stockUsers: [UserEntity], hasStock: Bool) = input
        
        let itemId = input.item.id
        let userId = input.item.user.id
        let title = input.item.title
        let tag = input.item.tagList.map { $0.name }.joined(separator: ", ")
        let profileURL = URL(string: input.item.user.profileImageUrlString)
        let userName = input.item.user.id
        
        let count = input.stockUsers.count
        var stockCount = "ストック数 " + count.description
        let suffix = count == 100 ? "+" : ""
        stockCount.append(suffix)
        
        let htmlRenderBody = input.item.renderedBody
        
        return ItemVM(itemId: itemId,
                      userId: userId,
                      title: title,
                      tag: tag,
                      profileURL: profileURL,
                      userName: userName,
                      stockCount: stockCount,
                      hasStock: input.hasStock,
                      htmlRenderBody: htmlRenderBody)
        
    }
    
}
