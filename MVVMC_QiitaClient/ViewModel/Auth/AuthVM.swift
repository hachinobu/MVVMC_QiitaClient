//
//  AuthVM.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import APIKit

final class AuthVM<Object: AccessTokenProtocol>: AuthViewModel {
        
    lazy var accessToken: Observable<String> = {
        return self.fetchTokenAction.elements
    }()
    
    lazy var error: Driver<Error> = {
        return self.fetchTokenAction.errors.asDriver(onErrorDriveWith: .empty())
            .flatMap { error -> Driver<Error> in
                switch error {
                case .underlyingError(let error):
                    return Driver.just(error)
                case .notEnabled:
                    return Driver.empty()
                }
            }
    }()
    
    var fetchTokenTrigger: PublishSubject<String> = PublishSubject<String>()
    private let fetchTokenAction: Action<String, String>
    private let bag = DisposeBag()
    
    init<Request: AuthRequest>(
        request: Request,
        session: Session = Session.shared) where Request.Response == Object {
        
        fetchTokenAction = Action { code in
            var authRequest = request
            authRequest.code = code
            return session.rx.response(request: authRequest).map { $0.fetchAccessToken() }
        }
        
        fetchTokenTrigger.subscribe(onNext: { [weak self] code in
            self?.fetchTokenAction.execute(code)
        }).addDisposableTo(bag)
        
    }
    
}
