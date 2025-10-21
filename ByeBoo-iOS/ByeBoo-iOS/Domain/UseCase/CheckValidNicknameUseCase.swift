//
//  CheckValidNicknameUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/21/25.
//

import Foundation

protocol CheckValidNicknameUseCase {
    func execute(nickname: String) -> Bool
}

enum NicknameRule {
    private static let regularExpression = "(?=.{2,5}$)(?!.*[ㄱ-ㅎㅏ-ㅣ])[가-힣a-zA-Z0-9]+"
    static let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
}

struct DefaultCheckValidNicknameUseCase: CheckValidNicknameUseCase {
        
    func execute(nickname: String) -> Bool {
        return NicknameRule.predicate.evaluate(with: nickname)
    }
}
