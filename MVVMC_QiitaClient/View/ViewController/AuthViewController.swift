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

class AuthViewController: UIViewController, AuthViewProtocol {

    private let tappedAuthButtonObserver = PublishSubject<Void>()
    lazy var tappedAuthButton: Observable<Void> = self.tappedAuthButtonObserver.asObservable()
    
    private let tappedNotAuthButtonObserver = PublishSubject<Void>()
    lazy var tappedNotAuthButton: Observable<Void> = self.tappedNotAuthButtonObserver.asObservable()
    
    private let bag = DisposeBag()
    
    @IBOutlet private weak var authButton: UIButton!
    @IBOutlet private weak var notAuthButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
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

}
