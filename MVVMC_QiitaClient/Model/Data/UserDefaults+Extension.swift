//
//  UserDefaults+Extension.swift
//  MVVMC_QiitaClient
//
//  Created by Takahiro Nishinobu on 2018/03/05.
//  Copyright © 2018年 hachinobu. All rights reserved.
//

import Foundation

protocol KeyNameSpaceable {
    associatedtype Key: RawRepresentable where Key.RawValue == String
}

extension KeyNameSpaceable {
    private static func namespace(key: String) -> String {
        return "\(Self.self)." + key
    }
    
    static func namespace<T: RawRepresentable>(key: T) -> String {
        return namespace(key: key)
    }
}

protocol UserDefaultable: KeyNameSpaceable {
    associatedtype ValueType
    static func set(value: ValueType, key: Key)
    static func value(key: Key) -> ValueType
}

extension UserDefaultable {
    static func set(value: ValueType, key: Key) {
        let key = namespace(key: key)
        UserDefaults.standard.set(value, forKey: key)
    }
}

extension UserDefaultable where ValueType == Bool {
    static func value(key: Key) -> ValueType {
        let key = namespace(key: key)
        return UserDefaults.standard.bool(forKey: key)
    }
}

extension UserDefaultable where ValueType == String {
    static func value(key: Key) -> ValueType {
        let key = namespace(key: key)
        return UserDefaults.standard.string(forKey: key) ?? ""
    }
}

extension UserDefaultable where ValueType == Int {
    static func value(key: Key) -> ValueType {
        let key = namespace(key: key)
        return UserDefaults.standard.integer(forKey: key)
    }
}

extension UserDefaults {
    
    struct BoolType: UserDefaultable {
        typealias ValueType = Bool
        private init() {}
        
        enum Key: String {
            case keyA
        }
    }
    
    struct StringType: UserDefaultable {
        typealias ValueType = String
        private init() {}
        
        enum Key: String {
            case accessToken
        }
    }
    
    struct IntType: UserDefaultable {
        typealias ValueType = Int
        private init() {}
        
        enum Key: String {
            case keyA
        }
    }
    
}

