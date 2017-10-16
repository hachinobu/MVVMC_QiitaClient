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
import Kingfisher
import WebKit

final class ItemDetailViewController: UIViewController, ItemDetailViewType {
    
    fileprivate var selectedUserObserver = PublishSubject<String>()
    lazy var selectedUser: Observable<String> = self.selectedUserObserver.asObservable()
    
    fileprivate var requiredAuthObserver = PublishSubject<Void>()
    lazy var requiredAuth: Observable<Void> = self.requiredAuthObserver.asObservable()
    
    fileprivate var selectedLikeCountObserver = PublishSubject<String>()
    lazy var selectedLikeCount: Observable<String> = self.selectedLikeCountObserver.asObservable()
    
    fileprivate var selectedStockCountObserver = PublishSubject<String>()
    lazy var selectedStockCount: Observable<String> = self.selectedStockCountObserver.asObservable()
    
    fileprivate var viewModel: ItemDetailViewModel!
    
    fileprivate let bag = DisposeBag()
    fileprivate var webContentHeight: CGFloat = 0.0
    fileprivate let tappedStockButtonObserver: PublishSubject<Void> = PublishSubject()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 90
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.register(type: ItemDetailWebTableCell.self)
            tableView.register(type: ItemDetailHeaderTableCell.self)
            tableView.tableFooterView = nil
        }
    }
    
    func injectViewModel(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        viewModel.viewDidLoadTrigger.onNext(())
    }

}

extension ItemDetailViewController {
    
    fileprivate func bindView() {
        
        let dataSource = ItemDetailTableViewDataSource(selectedUserObserver: selectedUserObserver,
                                                       tappedStockButtonObserver: tappedStockButtonObserver,
                                                       requiredAuthObserver: requiredAuthObserver)
        
        dataSource.selectedLikeCount
            .bind(to: selectedLikeCountObserver)
            .addDisposableTo(bag)
        
        dataSource.selectedStockCount
            .bind(to: selectedStockCountObserver)
            .addDisposableTo(bag)
        
        viewModel.itemDetail.map { [$0, $0] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(bag)
        
        tableView.delegate = dataSource
        
        viewModel.error.drive(onNext: { (error) in
            print(error)
        }).addDisposableTo(bag)
        
        tappedStockButtonObserver
            .bind(to: viewModel.updateStatusTrigger)
            .addDisposableTo(bag)
        
    }
    
}


fileprivate class ItemDetailTableViewDataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource, UITableViewDelegate {
    
    typealias Element = [ItemViewModel]
    
    var items: Element = []
    private var webContentCellHeight: CGFloat = 0.0
    let selectedUserObserver: PublishSubject<String>
    let tappedStockButtonObserver: PublishSubject<Void>
    let requiredAuthObserver: PublishSubject<Void>
    
    private let selectedLikeCountObserver = PublishSubject<String>()
    lazy var selectedLikeCount: Observable<String> = self.selectedLikeCountObserver.asObservable()
    
    private let selectedStockCountObserver = PublishSubject<String>()
    lazy var selectedStockCount: Observable<String> = self.selectedStockCountObserver.asObservable()
    
    init(selectedUserObserver: PublishSubject<String>, tappedStockButtonObserver: PublishSubject<Void>, requiredAuthObserver: PublishSubject<Void>) {
        self.selectedUserObserver = selectedUserObserver
        self.tappedStockButtonObserver = tappedStockButtonObserver
        self.requiredAuthObserver = requiredAuthObserver
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<[ItemViewModel]>) {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let viewModel = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ItemDetailHeaderTableCell
            viewModel.title.bind(to: cell.titleLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.likeCount.bind(to: cell.likeCountLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.stockCount.bind(to: cell.stockCountLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.userName.bind(to: cell.userNameButton.rx.title()).addDisposableTo(cell.bag)
            viewModel.tag.bind(to: cell.tagLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.hasStock.filter { $0 }.map { _ in "いいね済み" }.bind(to: cell.likeButton.rx.title()).addDisposableTo(cell.bag)
            viewModel.hasStock.filter { !$0 }.map { _ in "いいね" }.bind(to: cell.likeButton.rx.title()).addDisposableTo(cell.bag)
            
            viewModel.profileURL.filter { $0 != nil }.subscribe(onNext: { url in
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: resource, placeholder: nil,
                                                                       options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                                       progressBlock: nil, completionHandler: nil)
            }).addDisposableTo(cell.bag)
            
            cell.userNameButton.rx.tap.amb(cell.profileImageButton.rx.tap).map { _ in
                return viewModel.userId
            }.bind(to: selectedUserObserver).addDisposableTo(cell.bag)
            
            cell.likeCountButton.rx.tap.map { viewModel.itemId }.bind(to: selectedLikeCountObserver).addDisposableTo(cell.bag)
            cell.stockCountButton.rx.tap.map { viewModel.itemId }.bind(to: selectedStockCountObserver).addDisposableTo(cell.bag)
            
            let tap = cell.likeButton.rx.tap.map { AccessTokenStorage.hasAccessToken() }.shareReplayLatestWhileConnected()
            tap.filter { $0 }.map { _ in }.bind(to: tappedStockButtonObserver).addDisposableTo(cell.bag)
            tap.filter { !$0 }.map { _ in }.bind(to: requiredAuthObserver).addDisposableTo(cell.bag)
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ItemDetailWebTableCell
        
        cell.webView.rx.didFinishLoad.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            let height = cell.webView.scrollView.contentSize.height
            if strongSelf.webContentCellHeight == height {
                return
            }
            strongSelf.webContentCellHeight = height
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
        }).addDisposableTo(cell.bag)
        
        cell.webView.loadHTMLString(items.first!.htmlRenderBody, baseURL: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? UITableViewAutomaticDimension : webContentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? UITableViewAutomaticDimension : webContentCellHeight
    }
    
}



