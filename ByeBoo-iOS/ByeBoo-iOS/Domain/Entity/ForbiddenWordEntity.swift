//
//  ForbiddenWordEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/27/26.
//

struct ForbiddenWordEntity {
    let words: Set<String>
}

extension ForbiddenWordEntity {
    static func stub() -> Self {
        .init(words: ["word1", "word2", "word3"])
    }
}
