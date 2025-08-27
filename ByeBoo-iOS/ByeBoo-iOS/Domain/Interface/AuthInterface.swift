//
//  AuthInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 8/26/25.
//

import Foundation

protocol AuthInterface {
    func kakaoLogin() async throws
    func postLogin(platform: LoginPlatform) async throws
}
