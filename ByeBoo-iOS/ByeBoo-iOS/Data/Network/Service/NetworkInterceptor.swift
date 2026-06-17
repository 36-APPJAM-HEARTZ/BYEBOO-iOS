//
//  NetworkInterceptor.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/5/25.
//

import Foundation

import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    private let tokenService: TokenService
    private let keychainService: KeychainService
    private let retryLimit = 3
    
    init(
        tokenService: TokenService,
        keychainService: KeychainService
    ) {
        self.tokenService = tokenService
        self.keychainService = keychainService
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void) {
            var request = urlRequest
            guard request.value(forHTTPHeaderField: "X-Requires-Auth") == "true" else {
                completion(.success(request))
                return
            }
            request.headers.remove(name: "X-Requires-Auth")
            
            let accessToken = keychainService.load(key: .accessToken)
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            completion(.success(request))
        }
    
    func retry(
        _ request: Alamofire.Request,
        for session: Alamofire.Session,
        dueTo error: any Error,
        completion: @escaping @Sendable (Alamofire.RetryResult) -> Void) {
            
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
                return completion(.doNotRetryWithError(error))
            }
            
            guard request.retryCount < retryLimit else {
                return completion(.doNotRetryWithError(error))
            }
            
            Task {
                do {
                    try await self.tokenService.reissue()
                    ByeBooLogger.debug("401 Error -> 토큰 재발급 성공")
                    completion(.retry)
                } catch(let error as ByeBooError) {
                    completion(.doNotRetryWithError(error))
                }
            }
        }
}
