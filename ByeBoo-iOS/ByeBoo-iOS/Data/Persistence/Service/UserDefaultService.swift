//
//  UserDefaultService.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

protocol UserDefaultService {
    func save(_ value: Any, key: UserDefaultsKey) -> Bool
    func load<T>(key: UserDefaultsKey) -> T?
    func delete(key: UserDefaultsKey) -> Bool
}

struct DefaultUserDefaultService: UserDefaultService {
    func save(_ value: Any, key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        return UserDefaults.standard.value(forKey: key.rawValue) != nil
    }
    
    func load<T>(key: UserDefaultsKey) -> T? {
        UserDefaults.standard.value(forKey: key.rawValue) as? T
    }
    
    func delete(key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        return UserDefaults.standard.value(forKey: key.rawValue) == nil
    }
}

struct MockUserDefaultService: UserDefaultService {
    func save(_ value: Any, key: UserDefaultsKey) -> Bool {
        return true
    }
    
    func load<T>(key: UserDefaultsKey) -> T? {
        return 96 as? T
    }
    
    func delete(key: UserDefaultsKey) -> Bool {
        return true
    }
}
