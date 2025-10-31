//
//  CheckValidNicknameUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/21/25.
//

protocol CheckValidNicknameUseCase {
    func execute(nickname: String) -> Bool
}

struct DefaultCheckValidNicknameUseCase: CheckValidNicknameUseCase {
        
    func execute(nickname: String) -> Bool {
        return NicknameRule.predicate.evaluate(with: nickname)
    }
}
