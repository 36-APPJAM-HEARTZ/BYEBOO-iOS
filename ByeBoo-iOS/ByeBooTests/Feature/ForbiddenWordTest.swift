//
//  ForbiddenWordTest.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/28/26.
//

import Testing
@testable import ByeBoo_iOS

struct ForbiddenWordTest {
    
    private let repository = DefaultForbiddenWordRepository()
    private let isForbiddenWordUseCase: DefaultIsForbiddenWordUseCase
    
    init() {
        self.isForbiddenWordUseCase = DefaultIsForbiddenWordUseCase(repository: repository)
    }
    
    @Test(
        "🏁 단어에 금칙어가 포함되어있는 경우 ✅ true",
        arguments: ["10알", "10알아"]
    )
    func containsForbiddenWord__true(word: String) {
        let isForbiddenWord = isForbiddenWordUseCase.execute(word: word)
        
        #expect(isForbiddenWord == true)
    }
    
    @Test(
        "🏁 단어에 금칙어가 포함되어있지 않은 경우 ✅ false",
        arguments: ["주리", "승준", "나연"]
    )
    func containsForbiddenWord__false(word: String) {
        let isForbiddenWord = isForbiddenWordUseCase.execute(word: word)
        
        #expect(isForbiddenWord == false)
    }
}
