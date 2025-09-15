//
//  GetLastJourneyUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 9/13/25.
//

import Foundation

protocol GetLastJourneyUseCase {
    func execute() -> JourneyType
}

struct DefaultGetLastJourneyUseCase: GetLastJourneyUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() -> JourneyType {
        return repository.getLastJourneyType()
    }
}


