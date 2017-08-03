//
//  ItemDetailViewController.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemDetailViewController: UIViewController, ItemDetailViewType {
    
    fileprivate var selectedUserObserver = PublishSubject<String>()
    lazy var selectedUser: Observable<String> = self.selectedUserObserver.asObservable()
    
    private var viewModel: ItemDetailViewModel!
    
    func injectViewModel(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}
