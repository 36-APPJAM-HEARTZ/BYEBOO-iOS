//
//  Untitled.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/17/25.
//

import Foundation

protocol SetHelperUseCase {
    func execute()
}

struct DefaultSetHelperUseCase: SetHelperUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() {
        repository.setHelperShown()
    }
}
