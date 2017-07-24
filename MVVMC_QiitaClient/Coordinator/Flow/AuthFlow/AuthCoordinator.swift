//
//  AuthCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {

    private let bag = DisposeBag()
    private let viewFactory: AuthViewFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow: Observable<Void> = self.finishFlowObserver.asObservable()
    
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
        authView.tappedAuthButton.subscribe(onNext: { [unowned self] _ in
            self.authenticateQiita()
        }).addDisposableTo(bag)
        authView.tappedNotAuthButton.subscribe(onNext: { _ in
            
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: authView, hideBar: true)
    }
    
    private func authenticateQiita() {
        let url: String = "http://qiita.com/api/v2/oauth/authorize?client_id=\(AuthInfo.clientId)&scope=read_qiita+write_qiita&state=\(AuthInfo.accessTokenState)"
        UIApplication.shared.open(URL(string: url)!)
    }
    
}
