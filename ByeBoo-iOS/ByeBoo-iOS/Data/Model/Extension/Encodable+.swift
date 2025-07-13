//
//  Encodable+.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/13/25.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data)
        guard let dictionary = json as? [String: Any] else {
            throw ByeBooError.encodingError
        }
        
        return dictionary
    }
}
