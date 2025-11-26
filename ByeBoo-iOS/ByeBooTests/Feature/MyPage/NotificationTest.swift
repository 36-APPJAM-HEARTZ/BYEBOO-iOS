//
//  NotificationTest.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/26/25.
//

import Testing
@testable import ByeBoo_iOS

struct NotificationTest {
    
    private let token = "token"
    private let userDefaulsService = MockUserDefaultService()
    
    @Test(
        "🏁 알림 설정 권한 변경을 요청하면 ✅ !isAllowed",
        arguments: [false, true]
    )
    func updateNotificationPermission__isAllowed(isAllowed: Bool) async throws {
        let usersRepository = MockUserRepository()
        let changeNotificationPermissionUseCase = DefaultChangeNotificationPermissionUseCase(
            repository: usersRepository
        )
        usersRepository.isAllowed = isAllowed
        
        let updateResult = try await changeNotificationPermissionUseCase.execute()
        
        #expect(updateResult == !isAllowed)
    }
    
    @Test("🏁 loadToken 호출 시 ✅ 저장한 토큰 값이 나옴")
    func call_loadToken__token() {
        let notificationRepository = MockNotificationRepository(userDefaultsService: userDefaulsService)
        let _ = userDefaulsService.save(token, key: .fcmToken)
        
        let loadedToken = notificationRepository.loadToken()
        
        #expect(loadedToken == token)
    }
    
    @Test("🏁 sendToken 호출 시 ✅ 토큰이 성공적으로 저장됨")
    func call_sendToken__saveTokenSuccess() {
        let notificationRepository = MockNotificationRepository(userDefaultsService: userDefaulsService)
        
        notificationRepository.sendToken(token: token)
        
        let loadedToken = notificationRepository.loadToken()
        #expect(loadedToken == token)
        #expect(notificationRepository.sendTokenCalled)
    }
    
    @Test("🏁 saveToken 호출 시 ✅ 토큰이 성공적으로 저장됨")
    func call_saveToken__saveTokenSuccess() {
        let notificationRepository = MockNotificationRepository(userDefaultsService: userDefaulsService)
        
        notificationRepository.saveToken(token: token)
        
        let loadedToken = notificationRepository.loadToken()
        #expect(loadedToken == token)
    }
    
    @Test("🏁 updateToken 호출 시 ✅ 토큰이 성공적으로 저장됨")
    func call_updateToken__saveTokenSuccess() {
        let notificationRepository = MockNotificationRepository(userDefaultsService: userDefaulsService)
        
        notificationRepository.updateToken(token: token)
        
        let loadedToken = notificationRepository.loadToken()
        #expect(loadedToken == token)
        #expect(notificationRepository.updateTokenCalled)
    }
    
    @Test("🏁 deleteToken 호출 시 ✅ 토큰이 성공적으로 삭제됨")
    func call_deleteToken__saveTokenSuccess() {
        let notificationRepository = MockNotificationRepository(userDefaultsService: userDefaulsService)
        notificationRepository.saveToken(token: token)
        
        notificationRepository.deleteToken(token: token)
        
        let loadedToken = notificationRepository.loadToken()
        #expect(loadedToken == nil)
        #expect(notificationRepository.deleteTokenCalled)
    }
}
