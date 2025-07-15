//
//  GetUserIDUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/14/25.
//

protocol GetUserIDUseCase {
    func execute() -> Int?
}

struct DefaultGetUserIDUseCase: GetUserIDUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() -> Int? {
        return repository.getUserID()
    }
}
