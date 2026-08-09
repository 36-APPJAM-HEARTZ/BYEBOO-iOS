//
//  CommentRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/14/26.
//

import Foundation

struct DefaultCommentRepository: CommentInterface {
    
    private let network: NetworkService
    private let userDefaultServcie: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultServcie = userDefaultService
    }
    
    func postComment(content: String, answerID: Int) async throws {
        let postCommentRequestDTO: CommonQuestCommentRequestDTO = .init(content: content, targetId: answerID)
        let _ = try await network.request(CommentAPI.postComment(dto: postCommentRequestDTO))
    }
    
    func postReply(content: String, commentID: Int) async throws {
        let postReplyRequestDTO: CommonQuestReplyRequestDTO = .init(content: content)
        let _ = try await network.request(CommentAPI.postReply(commentID: commentID, dto: postReplyRequestDTO))
    }
    
    func fetchReplies(commentID: Int) async throws -> CommonQuestReplyListEntity {
        let userID: Int = userDefaultServcie.load(key: .userID) ?? 0
        let result = try await network.request(
            CommentAPI.fetchReplies(commentID: commentID),
            decodingType: CommonQuestAnswerRepliesResponseDTO.self
        )
        return result.toEntity(userID: userID)
    }
    
    func patchComment(content: String, commentID: Int) async throws {
        let patchCommentRequestDTO: CommonQuestReplyRequestDTO = .init(content: content)
        let _ = try await network.request(CommentAPI.patchComment(commentID: commentID, dto: patchCommentRequestDTO))
    }
    
    func deleteComment(commentID: Int) async throws {
        let _ = try await network.request(CommentAPI.deleteComment(commentID: commentID))
    }
}
