//
//  ItemListViewController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/25.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ItemListViewController: UIViewController, ItemListViewType {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var loadingIndicatorView = LoadingIndicatorView.loadView()
    
    let bag = DisposeBag()
    
    var viewModel: ItemListViewModel!
    
    fileprivate var selectedItemObserver = PublishSubject<String>()
    lazy var selectedItem: Observable<String> = self.selectedItemObserver.asObservable()
    
    lazy var reachedBottom: ControlEvent<Void> = self.tableView.rx.reachedBottom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
}

extension ItemListViewController {
    
    fileprivate func setupUI() {
        tableView.refreshControl = UIRefreshControl()
        tableView.tableFooterView = loadingIndicatorView
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(type: ItemListTableCell.self)
    }
    
    fileprivate func setupViewModel() {
        viewModel.bindRefresh(refresh: tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver())
        viewModel.bindReachedBottom(reachedBottom: tableView.rx.reachedBottom.asDriver())
        
    }
    
}
