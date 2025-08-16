//
//  GetHelperUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/17/25.
//

import Foundation

protocol GetHelperUseCase {
    func execute() -> Bool
}

struct DefaultGetHelperUseCase: GetHelperUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        return repository.getIsHelperShown() ?? false
    }
}

struct MockGetHelperUseCase: GetHelperUseCase {
    func execute() -> Bool {
        return false
    }
}
