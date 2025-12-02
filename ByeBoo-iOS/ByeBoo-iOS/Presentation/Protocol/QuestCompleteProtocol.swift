//
//  CountTextProtocol.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

protocol QuestCompleteProtocol: AnyObject {
    func changeCount(count: Int)
    func updateButtonWhenWriting(text: String)
}

extension QuestCompleteProtocol {
    func changeCount(count: Int) { return }
}
