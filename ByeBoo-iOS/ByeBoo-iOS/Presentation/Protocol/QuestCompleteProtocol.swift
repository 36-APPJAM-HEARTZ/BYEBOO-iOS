//
//  CountTextProtocol.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/8/25.
//

protocol QuestCompleteProtocol: AnyObject {
    func changeStyle(count: Int)
    func changeStyleWhenEditing(changedText: String)
}

extension QuestCompleteProtocol {
    func changeStyle(count: Int) { return }
    func changeStyleWhenEditing(changedText: String) { return }
}
