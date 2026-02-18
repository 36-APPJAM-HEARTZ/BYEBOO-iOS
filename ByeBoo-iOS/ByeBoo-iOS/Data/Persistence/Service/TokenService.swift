//
//  TokenService.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/16/25.
//

import Foundation

import Alamofire

protocol TokenService: Sendable {
    func reissue() async throws
}


actor DefaultTokenService: TokenService {
    private var tokenTask: Task<Void, Error>?
    private let keychainService: KeychainService
    
    
    init(keychainService: KeychainService) {
        self.keychainService = keychainService
    }
    
    func reissue() async throws {
        
        if let task = tokenTask {
            return try await task.value
        }
        
        let task = Task {
            try await fetchAuthReissue()
        }
        
        tokenTask = task
        defer { tokenTask = nil }
        
        return try await task.value
    }
    
    private func fetchAuthReissue() async throws {
        let header: HeaderType = .withAuth(acessToken: keychainService.load(key: .refreshToken))
        let endPoint: EndPoint = AuthAPI.reissue(header: header)
        ByeBooLogger.debug("토큰 재발급 시작")
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else {
                continuation.resume(throwing: ByeBooError.unknownError)
                return          
            }
            
            AF.request(
                endPoint.requestURL,
                method: endPoint.method,
                parameters: endPoint.bodyParameters,
                encoding: endPoint.parameterEncoding,
                headers: endPoint.headers.value
            )
            .validate()
            .responseDecodable(
                of: BaseResponse<TokenReissueResponseDTO>.self,
                queue: DispatchQueue.global()
            ) { [weak self] response in
                guard let self else {
                    continuation.resume(throwing: ByeBooError.unknownError)
                    return
                }
                ByeBooLogger.debug("💡Reissue \(response)")
                
                switch response.result {
                case .success(let data):
                    guard let data = data.data else {
                        ByeBooLogger.error(ByeBooError.noData)
                        continuation.resume(throwing: ByeBooError.noData)
                        return
                    }
                    
                    Task {
                        await self.tokenReissueSuccess(data)
                        continuation.resume(returning: ())
                    }
                    
                case .failure(let error):
                    Task {
                        await self.tokenReissueFail()
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    private func tokenReissueSuccess(_ data: TokenReissueResponseDTO) {
        ByeBooLogger.debug("토큰 재발급 완료")
        self.keychainService.save(key: .accessToken, token: data.accessToken)
        self.keychainService.save(key: .refreshToken, token: data.refreshToken)
    }
    
    private func tokenReissueFail() {
        ByeBooLogger.debug("토큰 재발급 실패, 키체인 삭제 후 로그인으로 이동")
        clearKeychain()
        Task { @MainActor in
            NotificationCenter.default.post(name: .navigateLoginViewController, object: nil)
        }
    }
    
    private func clearKeychain() {
        for key in KeyType.allCases {
            let token = keychainService.load(key: key)
            if !token.isEmpty {
                keychainService.delete(key: key)
                ByeBooLogger.debug("\(key) 삭제")
            }
        }
    }
    
}
