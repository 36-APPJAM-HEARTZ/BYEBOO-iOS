//
//  CheckHasEnterMyPageUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/30/25.
//

protocol CheckHasEnterMyPageUseCase {
    func execute() -> Bool
}

struct DefaultCheckHasEnterMyPageUseCase: CheckHasEnterMyPageUseCase {
    
    private let repository: UsersInterface
    
    init(repository: UsersInterface) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        repository.checkHasEnterMyPage()
    }
}
