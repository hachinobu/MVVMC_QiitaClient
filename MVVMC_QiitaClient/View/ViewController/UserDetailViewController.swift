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
import Kingfisher

class UserDetailViewController: UIViewController, UserDetailViewType {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var loadingIndicatorView = LoadingIndicatorView.loadView()
    
    let bag = DisposeBag()
    
    fileprivate var viewModel: UserDetailViewModel!
    
    fileprivate var selectedItemObserver = PublishSubject<String>()
    lazy var selectedItem: Observable<String> = self.selectedItemObserver.asObservable()
    
    fileprivate var selectedFollowerObserver = PublishSubject<String>()
    lazy var selectedFollower: Observable<String> = self.selectedFollowerObserver.asObservable()
    
    fileprivate var selectedFollowTagListObserver = PublishSubject<String>()
    lazy var selectedFollowTagList: Observable<String> = self.selectedFollowTagListObserver.asObservable()
    
    fileprivate var selectedFolloweeObserver = PublishSubject<String>()
    lazy var selectedFollowee: Observable<String> = self.selectedFolloweeObserver.asObservable()
    
    var isDisplayButton: Bool = false
    fileprivate var logoutActionObserver = PublishSubject<Void>()
    lazy var logoutAction: Observable<Void> = self.logoutActionObserver.asObservable()
    
    fileprivate let reachedBottomObserver: PublishSubject<Void> = PublishSubject()
    
    func injectViewModel(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        bindView()
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
        tableView.register(type: UserDetailTableCell.self)
    }
    
    fileprivate func setupViewModel() {
        viewModel.bindRefresh(refresh: tableView.refreshControl!.rx.controlEvent(.valueChanged).asDriver())
        viewModel.bindReachedBottom(reachedBottom: reachedBottomObserver.asDriver(onErrorDriveWith: .empty()))
    }
    
    fileprivate func bindView() {
        
        viewModel.isLoadingIndicatorAnimation
            .drive(loadingIndicatorView.indicator.rx.isAnimating)
            .addDisposableTo(bag)
        
        viewModel.isLoadingIndicatorAnimation
            .map { !$0 }
            .drive(loadingIndicatorView.indicator.rx.isHidden)
            .addDisposableTo(bag)
        
        viewModel.userDetailItemPairs
            .map { _ in false }
            .drive(tableView.refreshControl!.rx.isRefreshing.asObserver())
            .addDisposableTo(bag)
        
        let dataSource = UserDetailTableViewDataSource(isDisplayButton: isDisplayButton)
        
        dataSource.selectedItem
            .bind(to: selectedItemObserver)
            .addDisposableTo(bag)
        
        dataSource.selectedFolloweeList
            .bind(to: selectedFolloweeObserver)
            .addDisposableTo(bag)
        
        dataSource.selectedFollowerList
            .bind(to: selectedFollowerObserver)
            .addDisposableTo(bag)
        
        dataSource.selectedFollowTagList
            .bind(to: selectedFollowTagListObserver)
            .addDisposableTo(bag)
        
        dataSource.reachedBottom
            .bind(to: reachedBottomObserver)
            .addDisposableTo(bag)
        
        dataSource.logoutAction
            .bind(to: logoutActionObserver)
            .addDisposableTo(bag)
        
        viewModel.userDetailItemPairs
            .map { [$0, $0] }
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(bag)
        
        tableView.delegate = dataSource
        
    }
    
}


fileprivate class UserDetailTableViewDataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource, UITableViewDelegate {
    
    typealias Element = [(userDetail: UserDetailTableCellViewModel, userItems: [ItemListTableCellViewModel])]
    
    var items: Element = []
    
    private let selectedItemObserver = PublishSubject<String>()
    fileprivate lazy var selectedItem = self.selectedItemObserver.asObservable()
    
    private let selectedFolloweeListObserver = PublishSubject<String>()
    fileprivate lazy var selectedFolloweeList = self.selectedFolloweeListObserver.asObservable()
    
    private let selectedFollowerListObserver = PublishSubject<String>()
    fileprivate lazy var selectedFollowerList = self.selectedFollowerListObserver.asObservable()
    
    private let selectedFollowTagListObserver = PublishSubject<String>()
    fileprivate lazy var selectedFollowTagList = self.selectedFollowTagListObserver.asObservable()
    
    private let reachedBottomObserver = PublishSubject<Void>()
    fileprivate lazy var reachedBottom = self.reachedBottomObserver.asObservable()
    
    let isDisplayButton: Bool
    
    fileprivate var logoutActionObserver = PublishSubject<Void>()
    lazy var logoutAction: Observable<Void> = self.logoutActionObserver.asObservable()
    
    init(isDisplayButton: Bool) {
        self.isDisplayButton = isDisplayButton
    }
    
    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        if case .next(let items) = observedEvent {
            self.items = items
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return items[0].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let viewModel = items[0].userDetail
            let cell = tableView.dequeueReusableCell(indexPath: indexPath) as UserDetailTableCell
            viewModel.userId.bind(to: cell.userIdLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.userName.bind(to: cell.userNameLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.company.bind(to: cell.companyLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.itemCount.bind(to: cell.itemCountLabel.rx.text).addDisposableTo(cell.bag)
            viewModel.followeeUserCount.bind(to: cell.followeeUserCountLabel.rx.title()).addDisposableTo(cell.bag)
            viewModel.followerUserCount.bind(to: cell.followerUserCountLabel.rx.title()).addDisposableTo(cell.bag)
            viewModel.description.bind(to: cell.descriptionLabel.rx.attributedText).addDisposableTo(cell.bag)
            
            viewModel.profileURL.filter { $0 != nil }.subscribe(onNext: { url in
                
                let imageURL = url!
                let resource = ImageResource(downloadURL: imageURL, cacheKey: imageURL.absoluteString)
                cell.profileImageView.kf.indicatorType = .activity
                cell.profileImageView.kf.setImage(with: resource,
                                                  placeholder: nil,
                                                  options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                                  progressBlock: nil,
                                                  completionHandler: nil)
                
            }).addDisposableTo(cell.bag)
            
            cell.followTagListButton.rx.tap.withLatestFrom(viewModel.userId)
                .filter { $0 != nil }
                .map { $0! }
                .bind(to: self.selectedFollowTagListObserver)
                .addDisposableTo(cell.bag)
            
            cell.followeeUserCountLabel.rx.tap.withLatestFrom(viewModel.userId)
                .filter { $0 != nil }
                .map { $0! }
                .bind(to: self.selectedFolloweeListObserver)
                .addDisposableTo(cell.bag)
            
            cell.followerUserCountLabel.rx.tap.withLatestFrom(viewModel.userId)
                .filter { $0 != nil }
                .map { $0! }
                .bind(to: self.selectedFollowerListObserver)
                .addDisposableTo(cell.bag)
            
            cell.logoutButton.constraints
                .filter { $0.firstAttribute == .height }
                .first?.constant = isDisplayButton ? 30.0 : 0.0
            cell.logoutButton.rx.tap.bind(to: logoutActionObserver).addDisposableTo(cell.bag)
            
            return cell
            
        }
        
        let cell = tableView.dequeueReusableCell(indexPath: indexPath) as ItemListTableCell
        let viewModel = items[0].userItems[indexPath.row]
        viewModel.userName.bind(to: cell.userNameLabel.rx.text).addDisposableTo(cell.bag)
        viewModel.title.bind(to: cell.titleLabel.rx.attributedText).addDisposableTo(cell.bag)
        viewModel.likeCount.bind(to: cell.likeCountLabel.rx.text).addDisposableTo(cell.bag)
        viewModel.tag.bind(to: cell.tagLabel.rx.text).addDisposableTo(cell.bag)
        viewModel.profileURL.filter { $0 != nil }.map { $0! }.subscribe(onNext: { [weak cell] url in
            let resource = ImageResource(downloadURL: url, cacheKey: url.absoluteString)
            cell?.profileImageView.kf.indicatorType = .activity
            cell?.profileImageView.kf.setImage(with: resource, placeholder: nil,
                                               options: [.transition(ImageTransition.fade(1.0)), .cacheMemoryOnly],
                                               progressBlock: nil, completionHandler: nil)
            
        }).addDisposableTo(cell.bag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == items.count - 1 && indexPath.row == items[0].userItems.count - 1 else {
            return
        }
        reachedBottomObserver.onNext(())
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let viewModel = items[0].userItems[indexPath.row]
        selectedItemObserver.onNext(viewModel.itemId)
    }
    
}

