//
//  PostLoginResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

struct PostLoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let isRegistered: Bool
    let name: String?
    let journey: String?
    let journeyStatus: String?
}
