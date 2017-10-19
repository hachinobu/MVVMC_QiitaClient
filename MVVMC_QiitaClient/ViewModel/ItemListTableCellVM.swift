//
//  ItemListTableCellVM.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ItemListTableCellVM: ItemListTableCellViewModel {
    
    var itemId: String
    var userId: String
    
    private let profileURLObserver = Variable<URL?>(nil)
    lazy var profileURL: Observable<URL?> = self.profileURLObserver.asObservable()
    
    private let userNameObserver = Variable<String?>(nil)
    lazy var userName: Observable<String?> = self.userNameObserver.asObservable()
    
    private let likeCountObserver = Variable<String?>(nil)
    lazy var likeCount: Observable<String?> = self.likeCountObserver.asObservable()
    
    private let titleObserver = Variable<NSAttributedString?>(nil)
    lazy var title: Observable<NSAttributedString?> = self.titleObserver.asObservable()
    
    private let tagObserver = Variable<String?>(nil)
    lazy var tag: Observable<String?> = self.tagObserver.asObservable()
    
    init(itemId: String, userId: String, profileURL: URL?, userName: String?, likeCount: String?, title: NSAttributedString?, tag: String?) {
        self.itemId = itemId
        self.userId = userId
        self.profileURLObserver.value = profileURL
        self.userNameObserver.value = userName
        self.likeCountObserver.value = likeCount
        self.titleObserver.value = title
        self.tagObserver.value = tag
    }
    
}
