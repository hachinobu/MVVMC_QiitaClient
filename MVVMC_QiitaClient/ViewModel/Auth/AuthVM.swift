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

final class AuthVM<Response: AccessTokenProtocol>: AuthViewModel {
        
    lazy var accessToken: Driver<String> = {
        return self.fetchTokenAction.elements.asDriver(onErrorDriveWith: .empty())
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
    
    var fetchTokenTrigger: PublishSubject<Void> = PublishSubject<Void>()
    private let fetchTokenAction: Action<Void, String>
    private let bag = DisposeBag()
    
    init<Request: QiitaRequest>(
        request: Request,
        session: Session = Session.shared) where Request.Response == Response {
        
        fetchTokenAction = Action { _ in
            return session.rx.response(request: request).map { $0.fetchAccessToken() }
        }
        
        fetchTokenTrigger.subscribe(onNext: { [weak self] _ in
            self?.fetchTokenAction.execute(())
        }).addDisposableTo(bag)
        
    }
    
}
