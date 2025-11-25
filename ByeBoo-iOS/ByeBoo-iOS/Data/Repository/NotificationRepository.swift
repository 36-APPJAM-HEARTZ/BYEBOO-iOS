//
//  NotificationRepositoru.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/22/25.
//

struct DefaultNotificationRepository {
    
    private let network: NetworkService
    private let userDefaultsService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultsService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultsService = userDefaultsService
    }
    
    func loadToken() -> String? {
        guard let token: String = userDefaultsService.load(key: .fcmToken) else {
            return nil
        }
        return token
    }
    
    func sendToken(token: String) async throws {
        let fcmTokenDTO = createDTO(token: token)
        try await network.request(NotificationAPI.saveToken(dto: fcmTokenDTO))
        saveToken(token: token)
    }
    
    func saveToken(token: String) {
        let _ = userDefaultsService.save(token, key: .fcmToken)
    }
    
    func updateToken(token: String) async throws {
        let fcmTokenDTO = createDTO(token: token)
        try await network.request(NotificationAPI.updateToken(dto: fcmTokenDTO))
        let _ = userDefaultsService.save(token, key: .fcmToken)
    }
    
    func deleteToken(token: String) async throws {
        let fcmTokenDTO = createDTO(token: token)
        try await network.request(NotificationAPI.deleteToken(dto: fcmTokenDTO))
        let _ = userDefaultsService.delete(key: .fcmToken)
    }
    
    private func createDTO(token: String) -> FCMTokenDTO {
        .init(token: token)
    }
}
