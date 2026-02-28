//
//  IsForbiddenWordUseCase.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/27/26.
//

import Foundation

protocol IsForbiddenWordUseCase {
    func execute(word: String) -> Bool
}

struct DefaultIsForbiddenWordUseCase: IsForbiddenWordUseCase {
    
    private let repository: ForbiddenWordInterface
    
    init(repository: ForbiddenWordInterface) {
        self.repository = repository
    }
    
    func execute(word: String) -> Bool {
        guard let forbiddenWordEntity = repository.getForbiddenWords(word) else {
            return true
        }
        
        return forbiddenWordEntity.words.contains { word.contains($0) }
    }
}
