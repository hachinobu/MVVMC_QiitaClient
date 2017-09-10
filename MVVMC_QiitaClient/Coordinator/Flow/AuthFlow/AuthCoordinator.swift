//
//  AuthCoordinator.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/23.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift

final class AuthCoordinator: BaseCoordinator, CoordinatorFinishFlowType {

    private let bag = DisposeBag()
    private let moduleFactory: AuthModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    private let finishFlowObserver = PublishSubject<Void>()
    lazy var finishFlow: Observable<Void> = self.finishFlowObserver.asObservable()
    
    init(moduleFactory: AuthModuleFactory, coordinatorFactory: CoordinatorFactory, router: Router) {
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        let status = AuthenticateQiita.sharedInstance.status.value
        if !status.isAuthorized() {
            showAuthView()
        } else if status.isSkipAuth() {
            showLoginAuthView()
        }
    }
    
    private func showAuthView() {
        
        let authView = moduleFactory.generateAuthView()
        authView.tappedAuth.subscribe(onNext: { [weak self] _ in
            self?.authenticateQiita()
        }).addDisposableTo(bag)
        
        authView.tappedSkipAuth.do(onNext: { _ in
            AuthenticateQiita.sharedInstance.status.value = .skipAuth
        }).bind(to: finishFlowObserver).addDisposableTo(bag)
        
        authView.onCompleteAuth
            .map { token -> Bool in
                AuthenticateQiita.sharedInstance.status.value = .authenticated(token)
                return AccessTokenStorage.saveAccessToken(token: token)
            }.filter { $0 }
            .map { _ in }
            .bind(to: finishFlowObserver)
            .addDisposableTo(bag)
        
        router.setRoot(presentable: authView, hideBar: true)
    }
    
    private func showLoginAuthView() {
        
        let authView = moduleFactory.generateAuthView()
        authView.skipButtonHidden = true
        authView.closeButtonTapped.subscribe(onNext: { (_) in
            
        }).addDisposableTo(bag)
        authView.tappedAuth.subscribe(onNext: { [weak self] _ in
            self?.authenticateQiita()
        }).addDisposableTo(bag)
        
        router.setRoot(presentable: authView, hideBar: true)
        
    }
    
    private func authenticateQiita() {
        let url: String = "http://qiita.com/api/v2/oauth/authorize?client_id=\(AuthInfo.clientId)&scope=read_qiita+write_qiita&state=\(AuthInfo.accessTokenState)"
        UIApplication.shared.open(URL(string: url)!)
    }
    
    
    
}
