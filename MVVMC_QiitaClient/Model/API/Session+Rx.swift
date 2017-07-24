//
//  Session+Rx.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/24.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation
import APIKit
import RxSwift

extension Session {
    
    static func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
    
    private func rx_sendRequest<T: Request>(request: T) -> Observable<T.Response> {
        
        return Observable.create { observer -> Disposable in
            let task = self.send(request) { result in
                switch result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
        
    }
    
}
