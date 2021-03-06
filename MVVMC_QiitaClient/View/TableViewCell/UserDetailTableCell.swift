//
//  UserDetailTableCell.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/17.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

protocol UserDetailTableCellViewModel: class {
    var profileURL: Observable<URL?> { get }
    var userId: Observable<String?> { get }
    var userName: Observable<String?> { get }
    var company: Observable<String?> { get }
    var itemCount: Observable<String?> { get }
    var followeeUserCount: Observable<String?> { get }
    var followerUserCount: Observable<String?> { get }
    var description: Observable<NSAttributedString?> { get }
}

final class UserDetailTableCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var itemCountLabel: UILabel!
    @IBOutlet weak var followTagListButton: UIButton!
    @IBOutlet weak var followeeUserCountLabel: UIButton!
    @IBOutlet weak var followerUserCountLabel: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 8.0
        profileImageView.layer.masksToBounds = true
        logoutButton.layer.cornerRadius = 4.0
        logoutButton.layer.masksToBounds = true
        logoutButton.setTitle("ログアウト", for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

}
