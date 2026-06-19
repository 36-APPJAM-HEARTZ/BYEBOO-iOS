//
//  DeepLinkParser.swift
//  ByeBoo-iOS
//
//  Created by 더스틴 on 6/11/26.
//

import Foundation

struct DeepLinkParser {
    
    private static let scheme = "myapp"
    private static let idIndex = 1
    
    static func parse(from urlString: String) -> DeepLinkCoordinator? {
        guard let url = validateURL(from: urlString),
              let host = validateHost(from: url),
              let id = extractID(from: url)
        else {
            return nil
        }
        
        return destination(for: host, id: id)
    }
}

private extension DeepLinkParser {
    
    static func validateURL(from urlString: String) -> URL? {
        guard let url = URL(string: urlString),
              url.scheme == scheme
        else {
            return nil
        }
        
        return url
    }
    
    static func validateHost(from url: URL) -> DeepLinkHost? {
        guard let hostString = url.host,
              let host = DeepLinkHost(rawValue: hostString)
        else {
            return nil
        }
        
        return host
    }
    
    static func extractID(from url: URL) -> Int? {
        guard url.pathComponents.indices.contains(idIndex) else {
            return nil
        }
        
        return Int(url.pathComponents[idIndex])
    }
    
    static func destination(for host: DeepLinkHost, id: Int) -> DeepLinkCoordinator {
        switch host {
        case .quest:
            QuestDeepLinkCoordinator(questNumber: id)
        case .commonQuest:
            CommonQuestAnswerDeepLinkCoordinator(answerID: id)
        }
    }
}
