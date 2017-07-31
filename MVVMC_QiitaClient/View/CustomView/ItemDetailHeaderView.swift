//
//  ItemDetailHeaderView.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/31.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol ItemDetailHeaderViewModel: class {
    var itemId: String { get }
    var userId: String { get }
    var title: Observable<String?> { get }
    var tag: Observable<String?> { get }
    var profileURL: Observable<URL?> { get }
    var userName: Observable<String?> { get }
    var likeCount: Observable<String?> { get }
    var stockCount: Observable<String?> { get }
}

final class ItemDetailHeaderView: UIView, NibLoadableView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var stockCountLabel: UILabel!
    @IBOutlet weak var stockCountButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var stockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.layer.masksToBounds = true
        likeButton.layer.cornerRadius = 4.0
        likeButton.layer.masksToBounds = true
        stockButton.layer.cornerRadius = 4.0
        stockButton.layer.masksToBounds = true
    }
    
}
