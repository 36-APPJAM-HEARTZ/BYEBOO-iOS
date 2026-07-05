//
//  CheckForceUpdateUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/4/26.
//

import Foundation

protocol CheckForceUpdateUseCase {
    func execute() async -> Bool
}

struct DefaultCheckForceUpdateUsecase: CheckForceUpdateUseCase {
    
    private let repository: ForceUpdateInterface
    
    init(repository: ForceUpdateInterface) {
        self.repository = repository
    }
    
    func execute() async -> Bool {
        return await repository.checkForUpdate()
    }
}
