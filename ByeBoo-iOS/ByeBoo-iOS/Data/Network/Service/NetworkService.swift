//
//  NetworkService.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

import Alamofire

protocol NetworkService {
    func request<T: Decodable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) async throws -> T
}

struct DefaultNetworkService: NetworkService {
    func request<T: Decodable>(
        _ endPoint: EndPoint,
        decodingType: T.Type
    ) async throws -> T {
        
        ByeBooLogger.network("[Reqeust Start]")
        ByeBooLogger.network("URL: \(endPoint.requestURL)")
        ByeBooLogger.network("Method: \(endPoint.method.rawValue)")
        ByeBooLogger.network("Headers: \(endPoint.headers.value)")
        ByeBooLogger.network("Parameters: \(String(describing: endPoint.bodyParameters))")
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                endPoint.requestURL,
                method: endPoint.method,
                parameters: endPoint.bodyParameters,
                encoding: endPoint.parameterEncoding,
                headers: endPoint.headers.value
            )
            .validate()
            .responseDecodable(of: decodingType) { response in
                switch response.result {
                case .success(let data):
                    ByeBooLogger.data("Decoded Data: \(data)")
                    continuation.resume(returning: data)
                case .failure:
                    if let data = response.data,
                       let statusCode = response.response?.statusCode,
                       let errorResponse = try? JSONDecoder().decode(EmptyResponse.self, from: data) {
                        let error = ByeBooError.networkError(
                            code: statusCode,
                            message: errorResponse.message
                        )
                        ByeBooLogger.error(error)
                        continuation.resume(throwing: error)
                    }
                    
                    ByeBooLogger.error(ByeBooError.decodingError)
                    continuation.resume(throwing: ByeBooError.decodingError)
                }
            }
        }
    }
    
}
