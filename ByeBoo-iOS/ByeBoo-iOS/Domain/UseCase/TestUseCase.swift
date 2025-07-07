//
//  TestUseCase.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

protocol TestUseCase {
    func testFetchUserName() async throws -> String
}

struct DefaultTestUseCase: TestUseCase {
    private let testRepository: TestInterface
    
    init(testRepository: TestInterface) {
        self.testRepository = testRepository
    }
    
    func testFetchUserName() async throws -> String {
        return try await testRepository.fetchUserName()
    }
}

struct MockTestUseCase: TestUseCase {
    private let testRepository: TestInterface
    
    init(testRepository: TestInterface) {
        self.testRepository = testRepository
    }
    
    func testFetchUserName() -> String {
        return "name"
    }
}
