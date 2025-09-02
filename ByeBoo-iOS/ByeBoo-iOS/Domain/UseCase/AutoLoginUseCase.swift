//
//  AutoLoginUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/30/25.
//

import Foundation

protocol AutoLoginUseCase {
    func execute() -> Bool
}

struct DefaultAutoLoginUseCase: AutoLoginUseCase {
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        return repository.hasTokens()
    }
}
