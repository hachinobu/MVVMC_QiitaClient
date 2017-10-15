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
import Kingfisher
import APIKit

final class ItemListViewController: UIViewController, ItemListViewType {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var loadingIndicatorView = LoadingIndicatorView.loadView()
    
    let bag = DisposeBag()
    
    fileprivate var viewModel: ItemListViewModel!
    
    fileprivate var selectedItemObserver = PublishSubject<String>()
    lazy var selectedItem: Observable<String> = self.selectedItemObserver.asObservable()
    
    fileprivate var selectedUserObserver = PublishSubject<String>()
    lazy var selectedUser: Observable<String> = self.selectedUserObserver.asObservable()
    
    lazy var reachedBottom: ControlEvent<Void> = self.tableView.rx.reachedBottom
    
    func injectViewModel(viewModel: ItemListViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        bindTableView()
        viewModel.viewDidLoadTrigger.onNext(())
    }
    
}

extension ItemListViewController {
    
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
    
    fileprivate func bindTableView() {
        
        viewModel.isLoadingIndicatorAnimation
            .drive(loadingIndicatorView.indicator.rx.isAnimating)
            .addDisposableTo(bag)
        
        viewModel.isLoadingIndicatorAnimation
            .map { !$0 }
            .drive(loadingIndicatorView.indicator.rx.isHidden)
            .addDisposableTo(bag)
        
        viewModel.items
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .addDisposableTo(bag)
        
        viewModel.items
            .drive(tableView.rx.items(cellIdentifier: ItemListTableCell.nibName, cellType: ItemListTableCell.self)) { [weak self] row, cellViewModel, cell in
                
                guard let strongSelf = self else { return }
                
                cellViewModel.userName.bind(to: cell.userNameLabel.rx.text).addDisposableTo(cell.bag)
                cellViewModel.likeCount.bind(to: cell.likeCountLabel.rx.text).addDisposableTo(cell.bag)
                cellViewModel.title.bind(to: cell.titleLabel.rx.text).addDisposableTo(cell.bag)
                cellViewModel.tag.bind(to: cell.tagLabel.rx.text).addDisposableTo(cell.bag)
                cellViewModel.profileURL.filter { $0 != nil }.map { $0! }.subscribe(onNext: { [weak cell] url in
                    let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                    cell?.profileImageView.kf.indicatorType = .activity
                    cell?.profileImageView.kf.setImage(with: resource, placeholder: nil,
                                                       options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                       progressBlock: nil, completionHandler: nil)
                    
                }).addDisposableTo(cell.bag)
                
                cell.profileImageButton.rx.tap
                    .map { cellViewModel.userId }
                    .bind(to: strongSelf.selectedUserObserver)
                    .addDisposableTo(cell.bag)
                
        }.addDisposableTo(bag)
        
        tableView.rx.modelSelected(ItemListTableCellViewModel.self)
            .do(onNext: { [weak self] _ in
                if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }
            })
            .map { $0.itemId }
            .bind(to: selectedItemObserver)
            .addDisposableTo(bag)
        
        viewModel.error
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .addDisposableTo(bag)
        
        viewModel.error
            .filter { $0 as? QiitaError != nil }
            .map { $0 as! QiitaError }
            .drive(onNext: { error in
                print(error.message)
            }).addDisposableTo(bag)
        
    }
    
    
}
