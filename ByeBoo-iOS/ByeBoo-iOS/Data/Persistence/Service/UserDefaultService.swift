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

final class MockUserDefaultService: UserDefaultService {
    
    private var store: [UserDefaultsKey: Any] = [:]
    
    func save(_ value: Any, key: UserDefaultsKey) -> Bool {
        store[key] = value
        return true
    }
    
    func load<T>(key: UserDefaultsKey) -> T? {
        return store[key] as? T
    }
    
    func delete(key: UserDefaultsKey) -> Bool {
        guard let _ = store.removeValue(forKey: key) else {
            return false
        }
        return true
    }
    
    func deleteAll() {
        store.removeAll()
    }
}
