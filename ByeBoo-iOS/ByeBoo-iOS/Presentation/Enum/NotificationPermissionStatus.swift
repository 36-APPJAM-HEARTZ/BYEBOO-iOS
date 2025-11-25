//
//  NotificationPermissionStatus.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/25/25.
//

enum NotificationPermissionStatus {
    
    case authorized
    case denied
    
    var title: String {
        switch self {
        case .authorized:
            return "설정에서 기기 알림을 꺼주세요"
        case .denied:
            return "'ByeBoo'에서 알림을 보내고자 합니다."
        }
    }
    
    var message: String {
        let prefix = "설정>앱>알림에서 푸시 알림을"
        
        switch self {
        case .authorized:
            return "\(prefix) 꺼주세요."
        case .denied:
            return "\(prefix) 허용해주세요."
        }
    }
}
