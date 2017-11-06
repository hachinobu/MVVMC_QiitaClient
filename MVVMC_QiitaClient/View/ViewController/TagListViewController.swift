//
//  TagListViewController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/08/30.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class TagListViewController: UIViewController, TagListViewType {

    fileprivate let selectedTagIdObserver: PublishSubject<String> = PublishSubject()
    lazy var selectedTagId: Observable<String> = self.selectedTagIdObserver.asObservable()
    
    fileprivate let deinitViewObserver = PublishSubject<Void>()
    lazy var deinitView = self.deinitViewObserver.asObservable()
    
    fileprivate let bag = DisposeBag()
    fileprivate lazy var loadingIndicatorView = LoadingIndicatorView.loadView()
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var viewModel: TagListViewModel!
    
    func injectViewModel(viewModel: TagListViewModel) {
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

extension TagListViewController {
    
    fileprivate func setupUI() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.tintColor = loadingIndicatorView.indicator.color
        tableView.tableFooterView = loadingIndicatorView
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        tableView.register(type: TagListTableCell.self)
    }
    
    fileprivate func setupViewModel() {
        viewModel.bindRefresh(refresh: tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver())
        viewModel.bindReachedBottom(reachedBottom: tableView.rx.reachedBottom.asDriver())
    }
    
    fileprivate func bindView() {
        
        viewModel.isLoadingIndicatorAnimation
            .drive(loadingIndicatorView.indicator.rx.isAnimating)
            .addDisposableTo(bag)
        
        viewModel.isLoadingIndicatorAnimation
            .map { !$0 }
            .drive(loadingIndicatorView.indicator.rx.isHidden)
            .addDisposableTo(bag)
        
        viewModel.tags
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .addDisposableTo(bag)
        
        viewModel.tags
            .drive(tableView.rx.items(cellIdentifier: TagListTableCell.nibName, cellType: TagListTableCell.self)) { row, viewModel, cell in
                
                viewModel.tagName.bind(to: cell.tagNameLabel.rx.text).addDisposableTo(cell.bag)
                viewModel.tagCountInfo.bind(to: cell.tagCountLabel.rx.text).addDisposableTo(cell.bag)
                
                viewModel.tagImageURL.filter { $0 != nil }.map { $0! }.subscribe(onNext: { [weak cell] url in
                    let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
                    cell?.tagImageView.kf.indicatorType = .activity
                    cell?.tagImageView.kf.setImage(with: resource, placeholder: nil,
                                                       options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                       progressBlock: nil, completionHandler: nil)
                    
                }).addDisposableTo(cell.bag)
                
            }.addDisposableTo(bag)
        
        tableView.rx.modelSelected(TagListTableCellViewModel.self).do(onNext: { [weak self] _ in
            if let selectedIndexPath = self?.tableView.indexPathForSelectedRow {
                self?.tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }).map { $0.tagId }.bind(to: selectedTagIdObserver).addDisposableTo(bag)
        
        viewModel.error
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .addDisposableTo(bag)
        
        viewModel.error.drive(onNext: { (error) in
            print(error.localizedDescription)
        }).addDisposableTo(bag)
        
    }
    
}
