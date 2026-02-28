//
//  CheckValidNicknameUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/21/25.
//

protocol CheckValidNicknameUseCase {
    func isValidRegulation(nickname: String) -> Bool
    func isPermitteed(nickname: String) -> Bool
}

struct DefaultCheckValidNicknameUseCase: CheckValidNicknameUseCase {
        
    func isValidRegulation(nickname: String) -> Bool {
        return NicknameRule.predicate.evaluate(with: nickname)
    }
    
    func isPermitteed(nickname: String) -> Bool {
        return !NicknameRule.bannedWords.contains(nickname)
    }
}
