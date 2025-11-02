//
//  MyPageFeatureType.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/23/25.
//

import UIKit

enum MyPageFeatureType: String {
    
    case inquire = "문의하기"
    case notice = "알림"
    case termAndPolicy = "약관 및 정책"
    case account = "계정"
    
    var features: [MyPageDetailFeatureType] {
        switch self {
        case .inquire:
            return [.inquireByeBoo, .makeService]
        case .notice:
            return [.questOpenNotice]
        case .termAndPolicy:
            return [.privacyPolicy, .serviceTerm]
        case .account:
            return [.logout, .cancel]
        }
    }
}

enum MyPageDetailFeatureType: String {
    
    case inquireByeBoo = "바이부에 문의하기"
    case makeService = "바이부와 함께 서비스 만들기"
    case questOpenNotice = "퀘스트 오픈 알림"
    case privacyPolicy = "개인정보 처리 방침"
    case serviceTerm = "서비스 이용 약관"
    case logout = "로그아웃"
    case cancel = "탈퇴"
}
