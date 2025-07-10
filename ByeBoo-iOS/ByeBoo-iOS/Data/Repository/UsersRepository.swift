//
//  UsersRepository.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import Foundation

struct DefaultUsersRepository: UsersInterface {
    private let network: NetworkService
    
    init(network: NetworkService) {
        self.network = network
    }
    
    func getJourney() async throws -> JourneyEntity {
        let result = try await network.request(
            UsersAPI.journey(userID: 1),
            decodingType: UserJourneyResponseDTO.self
        )
        
        return result.toEntity()
    }
}

struct MockUserRepository: UsersInterface {
    func getJourney() async throws -> JourneyEntity {
        return .stub()
    }
}


