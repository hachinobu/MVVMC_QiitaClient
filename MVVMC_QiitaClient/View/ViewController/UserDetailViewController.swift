//
//  UserDetailViewController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/20.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class UserDetailViewController: UIViewController, UserDetailViewType {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var loadingIndicatorView = LoadingIndicatorView.loadView()
    
    let bag = DisposeBag()
    
    fileprivate var viewModel: UserDetailViewModel!
    
    fileprivate var selectedItemObserver = PublishSubject<String>()
    lazy var selectedItem: Observable<String> = self.selectedItemObserver.asObservable()
    
    lazy var reachedBottom: ControlEvent<Void> = self.tableView.rx.reachedBottom
    
    func injectViewModel(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoadTrigger.onNext(())
    }

}

extension UserDetailViewController {
    
    fileprivate func setupUI() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = loadingIndicatorView.indicator.color
        tableView.tableFooterView = loadingIndicatorView
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(type: ItemListTableCell.self)
    }
    
    fileprivate func setupViewModel() {
        viewModel.bindRefresh(refresh: tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver())
        viewModel.bindReachedBottom(reachedBottom: tableView.rx.reachedBottom.asDriver())
    }
    
    fileprivate func bindView() {
        
        
        
    }
    
}
