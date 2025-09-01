//
//  TokenReissueResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 9/1/25.
//

struct TokenReissueResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
}
