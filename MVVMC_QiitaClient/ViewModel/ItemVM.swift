//
//  ItemDetailVM.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/02.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

final class ItemVM: ItemViewModel {
    
    var itemId: String
    var userId: String
    var htmlRenderBody: String
    
    private let titleObserver = Variable<String?>(nil)
    lazy var title: Observable<String?> = self.titleObserver.asObservable()
    
    private let tagObserver = Variable<String?>(nil)
    lazy var tag: Observable<String?> = self.tagObserver.asObservable()
    
    private let profileURLObserver = Variable<URL?>(nil)
    lazy var profileURL: Observable<URL?> = self.profileURLObserver.asObservable()
    
    private let userNameObserver = Variable<String?>(nil)
    lazy var userName: Observable<String?> = self.userNameObserver.asObservable()
    
    private let likeCountObserver = Variable<String?>(nil)
    lazy var likeCount: Observable<String?> = self.likeCountObserver.asObservable()
    
    private let stockCountObserver = Variable<String?>(nil)
    lazy var stockCount: Observable<String?> = self.stockCountObserver.asObservable()
    
    private let hasStockObserver = Variable<Bool>(false)
    lazy var hasStock: Observable<Bool> = self.hasStockObserver.asObservable()
    
    init(itemId: String,
         userId: String,
         title: String?,
         tag: String?,
         profileURL: URL?,
         userName: String?,
         likeCount: String?,
         stockCount: String?,
         hasStock: Bool,
         htmlRenderBody: String) {
        
        self.itemId = itemId
        self.userId = userId
        self.titleObserver.value = title
        self.tagObserver.value = tag
        self.profileURLObserver.value = profileURL
        self.userNameObserver.value = userName
        self.likeCountObserver.value = likeCount
        self.stockCountObserver.value = stockCount
        self.hasStockObserver.value = hasStock
        self.htmlRenderBody = htmlRenderBody
        
    }
    
}
