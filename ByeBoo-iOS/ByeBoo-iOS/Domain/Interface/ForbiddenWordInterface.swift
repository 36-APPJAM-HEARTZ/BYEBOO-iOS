//
//  ForbiddenWordInterface.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/27/26.
//

protocol ForbiddenWordInterface {
    func getForbiddenWords(_ word: String) -> ForbiddenWordEntity?
}
