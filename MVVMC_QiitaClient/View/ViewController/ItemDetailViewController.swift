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
    fileprivate var webContentHeight: CGFloat = 0.0
    
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
        
        let dataSource = ItemDetailTableViewDataSource(selectedUserObserver: selectedUserObserver)
        
        viewModel.itemDetail.map { [$0, $0] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(bag)
        
        tableView.delegate = dataSource
        
        viewModel.error.drive(onNext: { (error) in
            print(error)
        }).addDisposableTo(bag)
        
    }
    
}


fileprivate class ItemDetailTableViewDataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource, UITableViewDelegate {
    
    typealias Element = [ItemViewModel]
    
    var items: Element = []
    private var webContentCellHeight: CGFloat = 0.0
    var selectedUserObserver: PublishSubject<String>
    
    init(selectedUserObserver: PublishSubject<String>) {
        self.selectedUserObserver = selectedUserObserver
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
            viewModel.stockCount.bind(to: cell.stockCountLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.userName.bind(to: cell.userNameButton.rx.title()).addDisposableTo(cell.bag)
            viewModel.tag.bind(to: cell.tagLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.hasStock.filter { $0 }.map { _ in "ストック済み" }.bind(to: cell.stockButton.rx.title()).addDisposableTo(cell.bag)
            viewModel.hasStock.filter { !$0 }.map { _ in "ストック" }.bind(to: cell.stockButton.rx.title()).addDisposableTo(cell.bag)
            
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
            
            return cell
            
        }
        
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
        return indexPath.row == 0 ? UITableViewAutomaticDimension : webContentCellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? UITableViewAutomaticDimension : webContentCellHeight
    }
    
}



