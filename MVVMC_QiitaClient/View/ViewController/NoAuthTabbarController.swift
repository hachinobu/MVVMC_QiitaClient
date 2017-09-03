//
//  NoAuthTabbarController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/09/03.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class NoAuthTabbarController: UITabBarController, UITabBarControllerDelegate, NoAuthTabSelectable {

    private var selectedItemTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedItemTabObservable: Observable<UINavigationController> =
        self.selectedItemTabObserver.asObservable()
    
    private var selectedTagTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedTagTabObservable: Observable<UINavigationController> =
        self.selectedTagTabObserver.asObservable()
    
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
        }
    }

}

fileprivate extension NoAuthTabbarController {
    
    enum NoAuthSelectedTab: Int {
        case item = 0
        case tag
    }
    
}
