//
//  TagListTableCell.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/29.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol TagListTableCellViewModel: class {
    var tagId: String { get }
    var tagName: Observable<String?> { get }
    var tagImageURL: Observable<URL?> { get }
    var tagCountInfo: Observable<String?> { get }
}

final class TagListTableCell: UITableViewCell {
    
    @IBOutlet weak var tagImageView: UIImageView!
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var tagCountLabel: UILabel!

    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagImageView.layer.cornerRadius = 8.0
        tagImageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
}
