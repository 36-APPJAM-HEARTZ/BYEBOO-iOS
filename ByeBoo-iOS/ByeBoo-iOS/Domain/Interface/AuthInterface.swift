//
//  AuthInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Foundation

protocol AuthInterface {
    func kakaoLogin(platform: LoginPlatform) async throws
    func appleLogin(platform: LoginPlatform) async throws
    func logout() async throws
    func withdraw() async throws
}
