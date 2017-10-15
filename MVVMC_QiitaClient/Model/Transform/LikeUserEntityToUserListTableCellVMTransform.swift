//
//  LikeUserEntityToUserListTableCellVMTransform.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/10/15.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct LikeUserEntityToUserListTableCellVMTransform: Transformable {
    
    func transform(input: LikeUserEntity) -> UserListTableCellViewModel {
        
        let userId = input.user.id
        let profileURL = URL(string: input.user.profileImageUrlString)
        let userName = input.user.id
        
        return UserListTableCellVM(userId: userId, profileURL: profileURL, userName: userName)
        
    }
    
}
