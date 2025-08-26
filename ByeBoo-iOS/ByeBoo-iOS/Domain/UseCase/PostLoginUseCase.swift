//
//  PostLoginUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Foundation

protocol PostLoginUseCase {
    func execute(platform: String) async throws
}

struct DefaultPostLoginUseCase: PostLoginUseCase {
    private var repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute(platform: String) async throws {
        return try await repository.postLogin(platform: platform)
    }
}
