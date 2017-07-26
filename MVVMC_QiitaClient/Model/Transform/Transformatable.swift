//
//  Transformatable.swift
//  MVVMC_QiitaClient
//
//  Created by Nishinobu.Takahiro on 2017/07/26.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

protocol Transformatable {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) throws -> Output
    
}
