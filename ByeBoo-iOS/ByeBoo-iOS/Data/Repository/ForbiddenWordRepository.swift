//
//  ForbiddenWordRepository.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/27/26.
//

import Foundation

final class DefaultForbiddenWordRepository: ForbiddenWordInterface {
    
    private let resource = "ForbiddenWords"
    private let fileExtension = "json"
    private var cachedForbiddenWords: ForbiddenWordEntity?
    
    func getForbiddenWords(_ word: String) -> ForbiddenWordEntity? {
        if let cached = cachedForbiddenWords {
            return cached
        }
        
        guard let url = fetchURL(),
              let forbiddenWordList = decodeForbiddenWords(url: url) else {
            return nil
        }
        
        let forbiddenWordEntity = forbiddenWordList.toEntity()
        cachedForbiddenWords = forbiddenWordEntity
        return forbiddenWordEntity
    }
    
    private func fetchURL() -> URL? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: fileExtension) else {
            ByeBooLogger.error(ByeBooError.fileNotFound)
            return nil
        }
        
        return url
    }
    
    private func decodeForbiddenWords(url: URL) -> ForbiddenWordList? {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ForbiddenWordList.self, from: data)
            return decodedData
        } catch {
            ByeBooLogger.error(ByeBooError.decodingError)
            return nil
        }
    }
}
