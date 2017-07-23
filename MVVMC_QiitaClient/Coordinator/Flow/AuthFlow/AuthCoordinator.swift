//
//  AuthCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class AuthCoordinator: BaseCoordinator {

    private let bag = DisposeBag()
    private let viewFactory: AuthViewFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(viewFactory: AuthViewFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.viewFactory = viewFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showAuthView()
    }
    
    private func showAuthView() {
        
        let authView = viewFactory.generateAuthView()
        authView.tappedAuthButton.subscribe(onNext: { _ in
            
        }).addDisposableTo(bag)
        authView.tappedNotAuthButton.subscribe(onNext: { _ in
            
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: authView, hideBar: true)
    }
    
}
