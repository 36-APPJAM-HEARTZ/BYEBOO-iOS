//
//  RemoteConfigeManager.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/2/26.
//

import FirebaseRemoteConfig

protocol ForceUpdateManager {
    func checkForUpdate() async -> Bool
}

final class DefaultForceUpdateManager: ForceUpdateManager {
    let remoteConfig = RemoteConfig.remoteConfig()

    init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        RemoteConfig.remoteConfig().configSettings = settings
    }

    func checkForUpdate() async -> Bool {
        do {
            try await remoteConfig.fetch()
            try await remoteConfig.activate()

            let minimumVersion = remoteConfig["min_version_code"].stringValue
            
            return isUpdateRequired(minimumVersion: minimumVersion)
        } catch {
            return false
        }
    }

    private var currentAppVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }

    private func isUpdateRequired(minimumVersion: String) -> Bool {
        ByeBooLogger.debug("현재버전: \(currentAppVersion), 최소버전: \(minimumVersion)")
        return currentAppVersion.compare(minimumVersion, options: .numeric) == .orderedAscending
    }
}
