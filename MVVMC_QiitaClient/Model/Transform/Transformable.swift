//
//  Transformatable.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol Transformable {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}

extension Sequence {
    
    func transform<T: Transformable>(transformable: T) -> [T.Output] where Iterator.Element == T.Input {
        return map { transformable.transform(input: $0) }
    }
    
}
