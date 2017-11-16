//
//  TagListTableCellVM.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class TagListTableCellVM: TagListTableCellViewModel {

    let tagId: String
    
    private let tagNameObserver = Variable<String?>(nil)
    lazy var tagName: Observable<String?> = self.tagNameObserver.asObservable()
    
    private let tagImageURLObserver = Variable<URL?>(nil)
    lazy var tagImageURL: Observable<URL?> = self.tagImageURLObserver.asObservable()
    
    private let tagCountInfoObserver = Variable<String?>(nil)
    lazy var tagCountInfo: Observable<String?> = self.tagCountInfoObserver.asObservable()
    
    init(tagId: String, tagName: String?, tagImageURL: URL?, tagCountInfo: String?) {
        self.tagId = tagId
        self.tagNameObserver.value = tagName
        self.tagImageURLObserver.value = tagImageURL
        self.tagCountInfoObserver.value = tagCountInfo
    }
    
}
