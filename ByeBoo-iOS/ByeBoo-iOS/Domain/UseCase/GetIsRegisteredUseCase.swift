//
//  GetIsRegisteredUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/27/25.
//

import Foundation

protocol GetIsRegisteredUseCase {
    func execute() -> Bool
}

struct DefaultGetIsRegisteredUseCase: GetIsRegisteredUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        return repository.getIsRegistered()
    }
}
