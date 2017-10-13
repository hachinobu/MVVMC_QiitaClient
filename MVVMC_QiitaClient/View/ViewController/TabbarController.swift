//
//  TabbarController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/19.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class TabbarController: UITabBarController, UITabBarControllerDelegate, TabSelectableView {
    
    lazy var itemTabNavigationController: UINavigationController = {
        guard let navigationController = viewControllers?[SelectedTab.item.rawValue] as? UINavigationController else {
            return UINavigationController()
        }
        return navigationController
    }()
    
    lazy var tagTabNavigationController: UINavigationController = {
        guard let navigationController = viewControllers?[SelectedTab.tag.rawValue] as? UINavigationController else {
            return UINavigationController()
        }
        return navigationController
    }()
    
    lazy var myAccountNavigationController: UINavigationController = {
        guard let navigationController = viewControllers?[SelectedTab.myAccount.rawValue] as? UINavigationController else {
            return UINavigationController()
        }
        return navigationController
    }()
    
    private var selectedItemTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedItemTabObservable: Observable<UINavigationController> =
        self.selectedItemTabObserver.asObservable()
    
    private var selectedTagTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedTagTabObservable: Observable<UINavigationController> =
        self.selectedTagTabObserver.asObservable()
    
    private var selectedMyAccountTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedMyAccountTabObservable: Observable<UINavigationController> =
        self.selectedMyAccountTabObserver.asObservable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        selectedIndex = SelectedTab.item.rawValue
        if let viewController = customizableViewControllers?.first {
            tabBarController(self, didSelect: viewController)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = viewControllers?[selectedIndex] as? UINavigationController,
            let selectedTab = SelectedTab(rawValue: selectedIndex) else {
            return
        }

        switch selectedTab {
        case .item:
            selectedItemTabObserver.onNext(navigationController)
        case .tag:
            selectedTagTabObserver.onNext(navigationController)
        case .myAccount:
            selectedMyAccountTabObserver.onNext(navigationController)
        }
    }

}

fileprivate extension TabbarController {
    
    enum SelectedTab: Int {
        case item = 0
        case tag
        case myAccount
    }
    
}
