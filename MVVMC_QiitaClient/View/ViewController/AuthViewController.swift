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

final class AuthViewController: UIViewController, AuthViewProtocol {

    private let tappedAuthButtonObserver = PublishSubject<Void>()
    lazy var tappedAuthButton: Observable<Void> = self.tappedAuthButtonObserver.asObservable()
    
    private let tappedNotAuthButtonObserver = PublishSubject<Void>()
    lazy var tappedNotAuthButton: Observable<Void> = self.tappedNotAuthButtonObserver.asObservable()
    
    private let onCompleteAuthObserver = PublishSubject<String>()
    lazy var onCompleteAuth: Observable<String> = self.onCompleteAuthObserver.asObservable()
    
    private let bag = DisposeBag()
    private var viewModel: AuthViewModel!
    
    @IBOutlet private weak var authButton: UIButton!
    @IBOutlet private weak var notAuthButton: UIButton!
    
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
    }
    
    private func bindUI() {
        authButton.rx.tap
            .bind(to: tappedAuthButtonObserver)
            .addDisposableTo(bag)
        
        notAuthButton.rx.tap
            .bind(to: tappedNotAuthButtonObserver)
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
