//
//  UserListTableCellVM.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/21.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class UserListTableCellVM: UserListTableCellViewModel {

    var userId: String
    
    private let profileURLObserver = Variable<URL?>(nil)
    lazy var profileURL: Observable<URL?> = self.profileURLObserver.asObservable()
    
    private let userNameObserver = Variable<String?>(nil)
    lazy var userName: Observable<String?> = self.userNameObserver.asObservable()
    
    init(userId: String, profileURL: URL?, userName: String?) {
        self.userId = userId
        self.profileURLObserver.value = profileURL
        self.userNameObserver.value = userName
    }
    
}
