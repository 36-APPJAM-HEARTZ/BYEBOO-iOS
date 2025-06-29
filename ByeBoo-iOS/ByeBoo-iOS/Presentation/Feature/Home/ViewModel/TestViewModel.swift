//
//  TestViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

final class TestViewModel {
    private let testUseCase: TestUseCase
    
    var name: String = ""
    
    init(testUseCase: TestUseCase) {
        self.testUseCase = testUseCase
    }
    
    func testFunction() {
        name = testUseCase.testFetchUserName()
    }
}
