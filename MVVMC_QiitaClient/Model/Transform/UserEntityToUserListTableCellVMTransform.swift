//
//  UserEntityToUserListTableCellVMTransform.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct UserEntityToUserListTableCellVMTransform: Transformable {
    
    func transform(input: UserEntity) -> UserListTableCellViewModel {
        
        let userId = input.id
        let profileURL = URL(string: input.profileImageUrlString)
        let userName = input.id
        
        return UserListTableCellVM(userId: userId, profileURL: profileURL, userName: userName)
        
    }
    
}
