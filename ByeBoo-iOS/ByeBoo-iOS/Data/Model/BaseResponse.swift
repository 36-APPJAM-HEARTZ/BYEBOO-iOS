//
//  BaseResponse.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/6/25.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool
    let message: String
    let data: T?
}

struct EmptyResponse: Decodable {
    let success: Bool
    let message: String
}
