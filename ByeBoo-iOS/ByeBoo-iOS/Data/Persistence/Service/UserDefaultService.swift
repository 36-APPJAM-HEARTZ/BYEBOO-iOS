//
//  UserDefaultService.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

protocol UserDefaultService {
    func save()
    func load()
    func delete()
}

struct DefaultUserDefaultService: UserDefaultService {
    func save() {
        // UD에 저장
    }
    
    func load() {
        //
    }
    
    func delete() {
        //
    }
}
