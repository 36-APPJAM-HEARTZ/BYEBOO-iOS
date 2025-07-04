//
//  String+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/5/25.
//

import Foundation

extension String {

    var isValidNickname: Bool {
        let regularExpression = "(?=.{2,5}$)(?!.*[ㄱ-ㅎㅏ-ㅣ])[가-힣a-zA-Z0-9]+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }
}
