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
    
    fileprivate var viewModel: ItemDetailViewModel!
    
    fileprivate let bag = DisposeBag()
    fileprivate lazy var itemHeaderView = ItemDetailHeaderView.loadView()
    fileprivate var webContentHeight: CGFloat = 0.0
    
    @IBOutlet weak var tableView: UITableView!
    
    func injectViewModel(viewModel: ItemDetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindView()
        viewModel.viewDidLoadTrigger.onNext(())
    }

}

extension ItemDetailViewController {
    
    fileprivate func setupUI() {
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(type: ItemDetailWebTableCell.self)
        tableView.tableHeaderView = itemHeaderView
    }
    
    fileprivate func bindView() {
        
        let dataSource = ItemDetailTableViewDataSource()
        
        viewModel.itemDetail.map { [$0] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(bag)
        
        tableView.delegate = dataSource
        viewModel.itemDetail.drive(onNext: { [weak self] headerViewModel in
            
            guard let strongSelf = self else { return }
            headerViewModel.title.bind(to: strongSelf.itemHeaderView.titleLabel.rx.text).addDisposableTo(strongSelf.bag)
            headerViewModel.stockCount.bind(to: strongSelf.itemHeaderView.stockCountLabel.rx.text).addDisposableTo(strongSelf.bag)
            headerViewModel.userName.bind(to: strongSelf.itemHeaderView.userNameButton.rx.title()).addDisposableTo(strongSelf.bag)
            headerViewModel.tag.bind(to: strongSelf.itemHeaderView.tagLabel.rx.text).addDisposableTo(strongSelf.bag)
            
            headerViewModel.profileURL.filter { $0 != nil }.subscribe(onNext: { url in
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                strongSelf.itemHeaderView.profileImageView.kf.indicatorType = .activity
                strongSelf.itemHeaderView.profileImageView.kf.setImage(with: resource, placeholder: nil,
                                                                          options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                                          progressBlock: nil, completionHandler: nil)
            }).addDisposableTo(strongSelf.bag)
            
            strongSelf.itemHeaderView.userNameButton.rx.tap
                .map { headerViewModel.userId }
                .bind(to: strongSelf.selectedUserObserver)
                .addDisposableTo(strongSelf.bag)
            
            strongSelf.itemHeaderView.profileImageButton.rx.tap
                .map { headerViewModel.userId }
                .bind(to: strongSelf.selectedUserObserver)
                .addDisposableTo(strongSelf.bag)
            
            
        }).addDisposableTo(bag)
        
        viewModel.error.drive(onNext: { (error) in
            print(error)
        }).addDisposableTo(bag)
        
    }
    
}


fileprivate class ItemDetailTableViewDataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource, UITableViewDelegate {
    
    typealias Element = [ItemViewModel]
    
    var items: Element = []
    private var webContentCellHeight: CGFloat = 0.0
    
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
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ItemDetailWebTableCell
        
        cell.webView.rx.didFinishLoad.subscribe(onNext: { [weak self] _ in
            guard let strongSelf = self else { return }
            if strongSelf.webContentCellHeight == cell.webView.scrollView.contentSize.height {
                return
            }
            strongSelf.webContentCellHeight = cell.webView.scrollView.contentSize.height
            tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }).addDisposableTo(cell.bag)
        
        cell.webView.loadHTMLString(items.first!.htmlRenderBody, baseURL: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return webContentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return webContentCellHeight
    }
    
}



