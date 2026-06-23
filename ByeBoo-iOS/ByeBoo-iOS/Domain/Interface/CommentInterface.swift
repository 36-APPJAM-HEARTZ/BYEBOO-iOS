//
//  CommentInterface.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/14/26.
//

import Foundation

protocol CommentInterface {
    func postComment(content: String, answerID: Int) async throws
    func postReply(content: String, commentID: Int) async throws
    func fetchReplies(commentID: Int) async throws -> CommonQuestReplyListEntity
    func patchComment(content: String, commentID: Int) async throws
    func deleteComment(commentID: Int) async throws
}
