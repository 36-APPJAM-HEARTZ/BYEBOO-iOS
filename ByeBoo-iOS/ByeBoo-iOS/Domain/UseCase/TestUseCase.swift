//
//  TestUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

protocol TestUseCase {
    func testFetchUserName() -> String
}

struct DefaultTestUseCase: TestUseCase {
    private let testRepository: TestRepository
    
    init(testRepository: TestRepository) {
        self.testRepository = testRepository
    }
    
    func testFetchUserName() -> String {
        return testRepository.fetchUserName()
    }
}

struct MockTestUseCase: TestUseCase {
    private let testRepository: TestRepository
    
    init(testRepository: TestRepository) {
        self.testRepository = testRepository
    }
    
    func testFetchUserName() -> String {
        return "name"
    }
}
