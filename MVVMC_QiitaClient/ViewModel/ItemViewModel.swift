//
//  ItemDetailViewModel.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/02.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import RxSwift

protocol ItemViewModel: class {
    var itemId: String { get }
    var userId: String { get }
    var title: Observable<NSAttributedString?> { get }
    var tag: Observable<String?> { get }
    var profileURL: Observable<URL?> { get }
    var userName: Observable<String?> { get }
    var likeCount: Observable<String?> { get }
    var stockCount: Observable<String?> { get }
    var hasLike: Observable<Bool> { get }
    
    var htmlRenderBody: String { get }
    
    func updateLikeStatus(status: Bool)
}
