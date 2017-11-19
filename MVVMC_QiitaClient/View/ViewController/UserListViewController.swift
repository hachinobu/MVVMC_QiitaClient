//
//  UserListViewController.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/08/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class UserListViewController: UIViewController, UserListViewType {

    fileprivate let selectedUserObserver = PublishSubject<String>()
    lazy var selectedUser: Observable<String> = self.selectedUserObserver.asObservable()
    
    fileprivate var viewModel: UserListViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var deinitViewObserver = PublishSubject<Void>()
    lazy var deinitView = self.deinitViewObserver.asObservable()
    
    fileprivate lazy var loadingIndicatorView = LoadingIndicatorView.loadView()
    let bag = DisposeBag()
    
    func injectViewModel(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        bindView()
        viewModel.viewDidLoadTrigger.onNext(())
    }
    
    deinit {
        deinitViewObserver.onNext(())
    }
    
}

extension UserListViewController {
    
    fileprivate func setupUI() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = loadingIndicatorView.indicator.color
        tableView.tableFooterView = loadingIndicatorView
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.register(type: UserListTableCell.self)
    }
    
    fileprivate func setupViewModel() {
        viewModel.bindRefresh(refresh: tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver())
        viewModel.bindReachedBottom(reachedBottom: tableView.rx.reachedBottom.asDriver())
    }
    
    fileprivate func bindView() {
        
        viewModel.isLoadingIndicatorAnimation
            .drive(loadingIndicatorView.indicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.isLoadingIndicatorAnimation
            .map { !$0 }
            .drive(loadingIndicatorView.indicator.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.items
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .disposed(by: bag)
        
        viewModel.items
            .drive(tableView.rx.items(cellIdentifier: UserListTableCell.nibName, cellType: UserListTableCell.self)) { row, viewModel, cell in
                
                viewModel.userName.bind(to: cell.userNameLabel.rx.text).disposed(by: cell.bag)
                
                viewModel.profileURL.filter { $0 != nil }.map { $0! }.subscribe(onNext: { [weak cell] url in
                    let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                    cell?.profileImageView.kf.indicatorType = .activity
                    cell?.profileImageView.kf.setImage(with: resource, placeholder: nil,
                                                       options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                       progressBlock: nil, completionHandler: nil)
                    
                }).disposed(by: cell.bag)
                
            }.disposed(by: bag)
        
        tableView.rx.modelSelected(UserListTableCellViewModel.self).do(onNext: { [weak self] _ in
            if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }).map { $0.userId }.bind(to: selectedUserObserver).disposed(by: bag)
        
        viewModel.error
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .disposed(by: bag)
        
        viewModel.error.drive(onNext: { (error) in
            print(error.localizedDescription)
        }).disposed(by: bag)
        
    }
    
}
