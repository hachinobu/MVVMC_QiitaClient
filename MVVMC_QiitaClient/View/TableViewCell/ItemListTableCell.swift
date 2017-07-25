//
//  ItemListTableCell.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol ItemListTableCellViewModel: class {
    var itemId: String { get }
    var profileURL: Observable<URL?> { get }
    var userName: Observable<String?> { get }
    var title: Observable<String?> { get }
    var tag: Observable<String?> { get }
}

class ItemListTableCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
