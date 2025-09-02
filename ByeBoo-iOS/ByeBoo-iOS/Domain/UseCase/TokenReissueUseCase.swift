//
//  tokenReissueUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/30/25.
//

import Foundation

protocol TokenReissueUseCase {
    func execute() async throws
}

struct DefaultTokenReissueUseCase: TokenReissueUseCase  {
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func execute() async throws {
        return try await repository.reissue()
    }
}
