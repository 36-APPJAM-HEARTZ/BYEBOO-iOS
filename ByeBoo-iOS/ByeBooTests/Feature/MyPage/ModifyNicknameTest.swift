//
//  ModifyNicknameTest.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/21/25.
//

import Testing
@testable import ByeBoo_iOS

struct ModifyNicknameTest {
    
    private let expectedNickname = "ByeBoo"
    
    @Test("🏁 닉네임을 \"ByeBoo\"로 수정했을 때 ✅ 닉네임은 ByeBoo")
    func modifyNickname__ByeBoo() async throws {
        let modifyNicknameUseCase = DefaultModifyNicknameUseCase(repository: MockUserRepository())
        
        let modifiedNickname = try await modifyNicknameUseCase.execute(name: expectedNickname)
        
        #expect(modifiedNickname == expectedNickname)
    }
}
