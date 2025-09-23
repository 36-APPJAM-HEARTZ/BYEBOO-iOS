//
//  TokenService.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/16/25.
//

import Foundation

import Alamofire

protocol TokenService {
    func reissue() async throws
}

final class DefaultTokenService: TokenService {
    private let keychainService: KeychainService
    
    init(
        keychainService: KeychainService
    ) {
        self.keychainService = keychainService
    }
    
    func reissue() async throws {
        let header: HeaderType = .withAuth(acessToken: keychainService.load(key: .refreshToken))
        ByeBooLogger.debug("토큰 재발급 시작")
        
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self else { return }
            
            AF.request(
                AuthAPI.reissue(header: header).requestURL,
                method: AuthAPI.reissue(header: header).method,
                parameters: AuthAPI.reissue(header: header).bodyParameters,
                encoding: AuthAPI.reissue(header: header).parameterEncoding,
                headers: AuthAPI.reissue(header: header).headers.value
            )
            .validate()
            .responseDecodable(of: BaseResponse<TokenReissueResponseDTO>.self) { [weak self] response in
                guard let self else { return }
                switch response.result {
                case .success(let data):
                    guard let data = data.data else {
                        ByeBooLogger.error(ByeBooError.noData)
                        continuation.resume(throwing: ByeBooError.noData)
                        return
                    }
                    ByeBooLogger.debug("토큰 재발급 완료")
                    self.keychainService.save(key: .accessToken, token: data.accessToken)
                    self.keychainService.save(key: .refreshToken, token: data.refreshToken)
                    continuation.resume(returning: ())
                case .failure(let error):
                    ByeBooLogger.debug("토큰 재발급 실패, 키체인 삭제 후 로그인으로 이동")
                    self.clearKeychain()
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .navigateLoginViewController, object: nil)
                    }
                    if let data = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(EmptyResponse.self, from: data) {
                        ByeBooLogger.error(error)
                        continuation.resume(throwing: error)
                    } else {
                        ByeBooLogger.error(ByeBooError.decodingError)
                        continuation.resume(throwing: ByeBooError.decodingError)
                    }
                }
            }
        }
    }
}

extension DefaultTokenService {
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
