//
//  JoinUserTest.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 10/23/25.
//

import Testing
@testable import ByeBoo_iOS

struct JoinUserTest {
    
    @Test("🏁 회원 정보 등록 ✅ success")
    func joinUserInformation__success() async throws {
        let sendUserUseCase = DefaultSenduserUseCase(repository: MockUserRepository())
        let feeling: Feeling = .exhausted
        let questStyle: SelectQuestType = .recording
        
        let result = try await sendUserUseCase.execute(
            name: "ByeBoo",
            feeling: feeling.key,
            questStyle: questStyle.key
        )
        
        #expect(result.id == 1)
        #expect(result.name == "ByeBoo")
    }
}
