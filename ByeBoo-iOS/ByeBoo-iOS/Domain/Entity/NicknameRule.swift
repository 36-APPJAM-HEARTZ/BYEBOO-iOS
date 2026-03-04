//
//  NicknameRule.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/21/25.
//

import Foundation

enum NicknameRule {
    private static let regularExpression = "(?=.{2,5}$)(?!.*[ㄱ-ㅎㅏ-ㅣ])[가-힣a-zA-Z0-9]+"
    static let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
    static let bannedWords: Set<String> = ["admin", "master", "test", "운영자", "관리자"]
}
