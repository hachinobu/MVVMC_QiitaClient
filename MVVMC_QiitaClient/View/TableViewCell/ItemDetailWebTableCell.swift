//
//  ItemDetailWebTableCell.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/31.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import WebKit

final class ItemDetailWebTableCell: UITableViewCell {
    
    lazy var wkWebView: WKWebView = {
        let wkWebView = WKWebView(frame: .zero)
        wkWebView.translatesAutoresizingMaskIntoConstraints = false
        wkWebView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        wkWebView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        wkWebView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        wkWebView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        return wkWebView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(wkWebView)
    }

}
