//
//  UserAndItemsPairToUserDetailTransform.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/18.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct UserAndItemsPairToUserDetailTransform: Transformable {
    
    func transform(input: (UserEntity, [ItemEntity])) -> (userDetailVM: UserDetailTableCellViewModel, itemsVM: [ItemListTableCellViewModel]) {
        
        let userDetailVM = UserEntityToUserDetailTableCellViewModelTransform().transform(input: input.0)
        let itemsVM = input.1.map { ItemEntityToCellViewModelTransform().transform(input: $0) }
        
        return (userDetailVM, itemsVM)
        
    }
    
}
