//
//  GetUserNameUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/11/25.
//

import Foundation

protocol GetUserNameUseCase {
    func execute() -> String
}

struct DefaultGetUserNameUseCase: GetUserNameUseCase {
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() -> String {
        return repository.getUserName() ?? "이름"
    }
}

struct MockGetUserNameUseCase: GetUserNameUseCase {
    func execute() -> String {
        return "하츠핑"
    }
}
