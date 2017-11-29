//
//  NoAuthTabbarController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class UnAuthenticatedTabbarController: UITabBarController, UITabBarControllerDelegate, UnAuthenticatedTabSelectableView {

    private var selectedItemTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedItemTabObservable = self.selectedItemTabObserver.asObservable()
    
    private var selectedTagTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedTagTabObservable = self.selectedTagTabObserver.asObservable()
    
    private var selectedSignInTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedSignInTabObservable = self.selectedSignInTabObserver.asObservable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        selectedIndex = NoAuthSelectedTab.item.rawValue
        if let viewController = customizableViewControllers?.first {
            tabBarController(self, didSelect: viewController)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationController = viewControllers?[selectedIndex] as? UINavigationController,
            let selectedTab = NoAuthSelectedTab(rawValue: selectedIndex) else {
                return
        }
        
        switch selectedTab {
        case .item:
            selectedItemTabObserver.onNext(navigationController)
        case .tag:
            selectedTagTabObserver.onNext(navigationController)
        case .signin:
            selectedSignInTabObserver.onNext(navigationController)
        }
    }

}

fileprivate extension UnAuthenticatedTabbarController {
    
    enum NoAuthSelectedTab: Int {
        case item = 0
        case tag
        case signin
    }
    
}
