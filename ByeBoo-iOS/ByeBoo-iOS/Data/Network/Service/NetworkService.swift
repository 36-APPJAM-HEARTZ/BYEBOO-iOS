//
//  NetworkService.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 6/25/25.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>() -> T
}

struct DefaultNetworkService: NetworkService {
    
    func request<T: Decodable>() -> T {
        // 네크워크 코드 ~
//        let data = ... // 서버로부터 받은 JSON data
//        let decoded = try! JSONDecoder().decode(T.self, from: data)
//        return decoded
        
        return UserResponseDTO(name: "", birth: "") as! T
    }
}
