//
//  ItemEntityToCellViewModelTransfom.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct ItemEntityToCellViewModelTransfom: Transformatable {
    
    typealias Input = ItemEntity
    typealias Output = ItemListTableCellViewModel
    
    func transform(input: ItemEntity) throws -> ItemListTableCellViewModel {
        
        fatalError()
        
    }
    
}
