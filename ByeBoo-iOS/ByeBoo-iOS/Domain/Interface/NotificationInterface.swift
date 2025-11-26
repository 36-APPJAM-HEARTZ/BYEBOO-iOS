//
//  NotificationInterface.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 11/26/25.
//

protocol NotificationInterface {
    func loadToken() -> String?
    func sendToken(token: String) async throws
    func saveToken(token: String)
    func updateToken(token: String) async throws
    func deleteToken(token: String) async throws
}
