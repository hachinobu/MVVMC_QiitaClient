//
//  ItemEntityToCellViewModelTransfom.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import UIKit

struct ItemEntityToCellViewModelTransform: Transformable {
    
    typealias Input = ItemEntity
    typealias Output = ItemListTableCellViewModel
    
    private var paragraphStyle: NSParagraphStyle {
        let lineHeight: CGFloat = 22.0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        return paragraphStyle
    }
    
    func transform(input: ItemEntity) -> ItemListTableCellViewModel {
        
        let itemId = input.id
        let userId = input.user.id
        let profileURL = URL(string: input.user.profileImageUrlString)
        let userName = input.user.id
        let likeCount = input.likeCount.description + " いいね"
        
        let attributedTitle = NSMutableAttributedString(string: input.title)
        attributedTitle.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedTitle.length))
        let tag = input.tagList.map { $0.name }.joined(separator: ",")
        let viewModel = ItemListTableCellVM(itemId: itemId,
                                            userId: userId,
                                            profileURL: profileURL,
                                            userName: userName,
                                            likeCount: likeCount,
                                            title: attributedTitle,
                                            tag: tag)
        
        return viewModel
        
    }
    
}
