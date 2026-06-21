//
//  ReportRequestDTO.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/16/26.
//

import Foundation

struct ReportRequestDTO: Encodable {
    let targetType: String
    let targetId: Int
}
