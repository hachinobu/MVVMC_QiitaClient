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

final class ItemDetailViewController: UIViewController, ItemDetailViewType {
    
    fileprivate var selectedUserObserver = PublishSubject<String>()
    lazy var selectedUser: Observable<String> = self.selectedUserObserver.asObservable()
    
    fileprivate var viewModel: ItemDetailViewModel!
    
    fileprivate let bag = DisposeBag()
    fileprivate lazy var itemHeaderView = ItemDetailHeaderView.loadView()
    
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
        
        viewModel.itemDetail
            .map { [$0] }
            .drive(tableView.rx.items(cellIdentifier: ItemDetailWebTableCell.nibName, cellType: ItemDetailWebTableCell.self)) { row, cellViewModel, cell in
                cell.wkWebView.loadHTMLString(cellViewModel.htmlRenderBody, baseURL: nil)
            }.addDisposableTo(bag)
        
        viewModel.itemDetail.drive(onNext: { [weak self] headerViewModel in
            
            guard let strongSelf = self else { return }
            headerViewModel.title.bind(to: strongSelf.itemHeaderView.titleLabel.rx.text).addDisposableTo(strongSelf.bag)
            headerViewModel.stockCount.bind(to: strongSelf.itemHeaderView.stockCountLabel.rx.text).addDisposableTo(strongSelf.bag)
            headerViewModel.userName.bind(to: strongSelf.itemHeaderView.userNameButton.titleLabel!.rx.text).addDisposableTo(strongSelf.bag)
            
            headerViewModel.profileURL.filter { $0 != nil }.subscribe(onNext: { url in
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                strongSelf.itemHeaderView.profileImageView.kf.indicatorType = .activity
                strongSelf.itemHeaderView.profileImageView.kf.setImage(with: resource, placeholder: nil,
                                                                          options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                                          progressBlock: nil, completionHandler: nil)
            }).addDisposableTo(strongSelf.bag)
            
            strongSelf.itemHeaderView.profileImageButton.rx.tap
                .map { headerViewModel.userId }
                .bind(to: strongSelf.selectedUserObserver)
                .addDisposableTo(strongSelf.bag)
            
            
            
        }).addDisposableTo(bag)
        
    }
    
}
