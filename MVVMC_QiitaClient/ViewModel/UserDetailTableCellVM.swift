//
//  UserDetailTableCellVM.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class UserDetailTableCellVM: UserDetailTableCellViewModel {

    private let profileURLObserver = Variable<URL?>(nil)
    lazy var profileURL: Observable<URL?> = self.profileURLObserver.asObservable()
    
    private let userIdObserver = Variable<String?>(nil)
    lazy var userId: Observable<String?> = self.userIdObserver.asObservable()
    
    private let userNameObserver = Variable<String?>(nil)
    lazy var userName: Observable<String?> = self.userNameObserver.asObservable()
    
    private let companyObserver = Variable<String?>(nil)
    lazy var company: Observable<String?> = self.companyObserver.asObservable()
    
    private let itemCountObserver = Variable<String?>(nil)
    lazy var itemCount: Observable<String?> = self.itemCountObserver.asObservable()
    
    private let followeeUserCountObserver = Variable<String?>(nil)
    lazy var followeeUserCount: Observable<String?> = self.followeeUserCountObserver.asObservable()
    
    private let followerUserCountObserver = Variable<String?>(nil)
    lazy var followerUserCount: Observable<String?> = self.followerUserCountObserver.asObservable()
    
    private let descriptionObserver = Variable<String?>(nil)
    lazy var description: Observable<String?> = self.descriptionObserver.asObservable()
    
    init(profileURL: URL?, userId: String?, userName: String?, company: String?,
         itemCount: String?, followeeUserCount: String?, followerUserCount: String?, description: String?) {
        
        self.profileURLObserver.value = profileURL
        self.userIdObserver.value = userId
        self.userNameObserver.value = userName
        self.companyObserver.value = company
        self.itemCountObserver.value = itemCount
        self.followeeUserCountObserver.value = followeeUserCount
        self.followerUserCountObserver.value = followerUserCount
        self.descriptionObserver.value = description
        
    }
    
}
