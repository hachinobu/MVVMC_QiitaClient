//
//  ItemDetailHeaderTableCell.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/10.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class ItemDetailHeaderTableCell: UITableViewCell {

    var bag = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userNameButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var stockCountLabel: UILabel!
    @IBOutlet weak var stockCountButton: UIButton!
    @IBOutlet weak var stockButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.layer.masksToBounds = true
        stockButton.layer.cornerRadius = 4.0
        stockButton.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

}
