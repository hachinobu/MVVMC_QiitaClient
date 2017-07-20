//
//  TabbarController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/19.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

class TabbarController: UITabBarController, UITabBarControllerDelegate, TabSelectable {
    
    private var selectedTimeLineTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedTimeLineTabObservable: Observable<UINavigationController> =
        self.selectedTimeLineTabObserver.asObservable()
    
    private var selectedMyAccountTabObserver = PublishSubject<UINavigationController>()
    lazy var selectedMyAccountTabObservable: Observable<UINavigationController> =
        self.selectedMyAccountTabObserver.asObservable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        selectedIndex = SelectedTab.timeLine.rawValue
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
        case .timeLine:
            selectedTimeLineTabObserver.onNext(navigationController)
        case .myAccount:
            selectedMyAccountTabObserver.onNext(navigationController)
        }
    }

}

fileprivate extension TabbarController {
    
    enum SelectedTab: Int {
        case timeLine = 0
        case myAccount
    }
    
}
