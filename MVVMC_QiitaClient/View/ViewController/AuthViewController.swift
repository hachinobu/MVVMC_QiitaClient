//
//  AuthViewController.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/22.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class AuthViewController: UIViewController, AuthViewType {

    private let tappedAuthObserver = PublishSubject<Void>()
    lazy var tappedAuth: Observable<Void> = self.tappedAuthObserver.asObservable()
    
    private let tappedSkipAuthObserver = PublishSubject<Void>()
    lazy var tappedSkipAuth: Observable<Void> = self.tappedSkipAuthObserver.asObservable()
    
    private let onCompleteAuthObserver = PublishSubject<String>()
    lazy var onCompleteAuth: Observable<String> = self.onCompleteAuthObserver.asObservable()
    
    private let closeButtonTappedObserver = PublishSubject<Void>()
    lazy var closeButtonTapped: Observable<Void> = self.closeButtonTappedObserver.asObservable()
    
    var skipButtonHidden: Bool = false
    
    private let bag = DisposeBag()
    private var viewModel: AuthViewModel!
    
    @IBOutlet private weak var authButton: UIButton!
    @IBOutlet weak var skipAuthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        bindAuth()
    }
    
    func injectViewModel(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }
    
    private func setupUI() {
        authButton.layer.cornerRadius = 4.0
        skipAuthButton.isHidden = skipButtonHidden
    }
    
    private func bindUI() {
        authButton.rx.tap
            .bind(to: tappedAuthObserver)
            .addDisposableTo(bag)
        
        skipAuthButton.rx.tap
            .bind(to: tappedSkipAuthObserver)
            .addDisposableTo(bag)
    }
    
    private func bindAuth() {
        
        let authStatus = AuthenticateQiita.sharedInstance.status.asObservable().shareReplayLatestWhileConnected()
        authStatus.map { $0.fetchCode() }
            .filter { $0 != nil }
            .map { $0! }
            .bind(to: viewModel.fetchTokenTrigger)
            .addDisposableTo(bag)
        
        viewModel.accessToken
            .bind(to: onCompleteAuthObserver)
            .addDisposableTo(bag)
        
    }

}
