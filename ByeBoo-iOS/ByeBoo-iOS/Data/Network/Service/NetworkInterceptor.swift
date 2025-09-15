//
//  NetworkInterceptor.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/5/25.
//

import Foundation

import Alamofire

final class NetworkInterceptor: RequestInterceptor {
    private let tokenReissue: TokenReissue
    private let retryLimit = 3
    
    init(tokenReissue: TokenReissue) {
        self.tokenReissue = tokenReissue
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Alamofire.Session,
        completion: @escaping @Sendable (Result<URLRequest, any Error>) -> Void) {
            completion(.success(urlRequest))
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
                    try await self.tokenReissue.reissue()
                    ByeBooLogger.debug("401 Error -> 토큰 재발급 성공")
                    completion(.retry)
                } catch {
                    ByeBooLogger.debug("401 Error -> 토큰 재발급 실패, 로그인VC로 이동")
                    NotificationCenter.default.post(name: .navigateLoginViewController, object: nil)
                    completion(.doNotRetryWithError(error))
                }
            }
        }
}
