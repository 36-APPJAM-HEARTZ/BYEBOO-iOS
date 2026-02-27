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
    case participant = "참여하기"
    case manage = "관리"
    case termAndPolicy = "약관 및 정책"
    case account = "계정"
    
    var features: [MyPageDetailFeatureType] {
        switch self {
        case .inquire:
            return [.inquireByeBoo, .makeService]
        case .notice:
            return [.questOpenNotice]
        case .participant:
            return [.chattingRoom, .instagram]
        case .manage:
            return [.blockUserList]
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
    case chattingRoom = "이별 극복 소통방"
    case instagram = "공식 인스타그램"
    case blockUserList = "차단 사용자 목록"
    case privacyPolicy = "개인정보 처리 방침"
    case serviceTerm = "서비스 이용 약관"
    case logout = "로그아웃"
    case cancel = "탈퇴"
}
