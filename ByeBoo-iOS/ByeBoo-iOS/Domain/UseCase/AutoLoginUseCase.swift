//
//  AutoLoginUseCase.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/30/25.
//

import Foundation

protocol AutoLoginUseCase {
    func autoLogin() async throws -> Bool
    func clearKeychain()
}

struct DefaultAutoLoginUseCase: AutoLoginUseCase {
    private let repository: AuthInterface
    
    init(repository: AuthInterface) {
        self.repository = repository
    }
    
    func autoLogin()  async throws  -> Bool {
        return try await repository.autoLogin()
    }
    
    func clearKeychain() {
        repository.clearKeychain()
    }
}
