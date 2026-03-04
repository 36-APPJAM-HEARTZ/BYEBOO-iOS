//
//  ForbiddenWordList.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/27/26.
//

import Foundation

struct ForbiddenWordList: Decodable {
    let words: Set<String>
}

extension ForbiddenWordList {
    
    func toEntity() -> ForbiddenWordEntity {
        .init(words: words)
    }
}
