//
//  NetworkService.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

import Alamofire
import KakaoSDKUser

protocol NetworkService {
    func request<T: Decodable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) async throws -> T
    func request(_ endPoint: EndPoint) async throws
    func request(image: Data, signedURL: String) async throws
    func request() async throws -> String
}

struct DefaultNetworkService: NetworkService {
    func request<T: Decodable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) async throws -> T {
        requestLogger(endPoint)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                endPoint.requestURL,
                method: endPoint.method,
                parameters: endPoint.bodyParameters,
                encoding: endPoint.parameterEncoding,
                headers: endPoint.headers.value
            )
            .validate()
            .responseDecodable(of: BaseResponse<T>.self) { response in
                responseLogger(response)
                switch response.result {
                case .success(let data):
                    guard let data = data.data else {
                        ByeBooLogger.error(ByeBooError.noData)
                        continuation.resume(throwing: ByeBooError.noData)
                        return
                    }
                    ByeBooLogger.data("Decoded Data: \(data)")
                    continuation.resume(returning: data)
                case .failure:
                    if let data = response.data,
                       let statusCode = response.response?.statusCode,  
                       let errorResponse = try? JSONDecoder().decode(EmptyResponse.self, from: data) {
                        let error = handleError(statusCode, errorResponse.message)
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
    
    /// data가 없는 경우 네트워크 처리
    func request(_ endPoint: EndPoint) async throws {
        requestLogger(endPoint)
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                endPoint.requestURL,
                method: endPoint.method,
                parameters: endPoint.bodyParameters,
                encoding: endPoint.parameterEncoding,
                headers: endPoint.headers.value
            )
            .validate()
            .responseDecodable(of: EmptyResponse.self) { response in
                responseLogger(response)
                
                switch response.result {
                case .success:
                    continuation.resume(returning: ())
                case .failure:
                    if let data = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(EmptyResponse.self, from: data) {
                        let error = handleError(statusCode, errorResponse.message)
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
    
    /// 이미지 처리
    func request(image: Data, signedURL: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(
                image,
                to: signedURL,
                method: .put,
                headers: ["Content-Type": "image/jpeg"]
            )
                   .validate()
                   .response { response in
                       ByeBooLogger.network(response)
                       if let error = response.error {
                           ByeBooLogger.error(error)
                           continuation.resume(throwing: ByeBooError.unknownError)
                       } else {
                           ByeBooLogger.debug("이미지 업로드 성공")
                           continuation.resume()
                       }
                   }
           }
    }
    
    func request() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { ouathToken, error in
                    if let error = error {
                        ByeBooLogger.error(error)
                        continuation.resume(throwing: ByeBooError.unknownError)
                    } else {
                        ByeBooLogger.debug("카카오 로그인 토큰 받기 성공")
                        continuation.resume(returning: ouathToken?.accessToken ?? "")
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { ouathToken, error in
                    if let error = error {
                        ByeBooLogger.error(error)
                        continuation.resume(throwing: ByeBooError.unknownError)
                    } else {
                        ByeBooLogger.debug("카카오 로그인 토큰 받기 성공")
                        continuation.resume(returning: ouathToken?.accessToken ?? "")
                    }
                }
            }
            
        }
    }
    
    private func requestLogger(_ endPoint: EndPoint) {
        ByeBooLogger.network("[Reqeust Start]")
        ByeBooLogger.network("URL: \(endPoint.requestURL)")
        ByeBooLogger.network("Method: \(endPoint.method.rawValue)")
        ByeBooLogger.network("Headers: \(endPoint.headers.value)")
        ByeBooLogger.network("Parameters: \(String(describing: endPoint.bodyParameters))")
    }
    
    private func responseLogger<T>(_ response: DataResponse<T, AFError>) {
        ByeBooLogger.network("[Response Start]")
        ByeBooLogger.network("StatusCode: \(response.response!.statusCode)")
        ByeBooLogger.network("Header: \(response.response!.headers)")
        ByeBooLogger.network("Description: \(response.response!.description)")
    }
    
    private func handleError(_ statusCode: Int, _ errorResponse: String) -> ByeBooError {
        let error: ByeBooError
        
        if statusCode == 404 {
            error = ByeBooError.notFoundQuest
        } else if statusCode == 400 {
            error = ByeBooError.beforeJourney
        } else {
            error = ByeBooError.networkError(
                code: statusCode,
                message: errorResponse
            )
        }
        
        return error
    }
}
