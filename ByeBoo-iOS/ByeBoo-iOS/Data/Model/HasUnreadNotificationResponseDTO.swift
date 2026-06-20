//
//  HasUnreadNotificationResponseDTO.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/19/26.
//

struct HasUnreadNotificationResponseDTO: Decodable {
    let hasUnread: Bool
}

extension HasUnreadNotificationResponseDTO {
    func toEntity() -> HasUnreadNotificationEntity {
        .init(hasUnread: hasUnread)
    }
}
