//
//  CommentAPI.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 6/14/26.
//

import Foundation

import Alamofire

enum CommentAPI {
    case postComment(dto: CommonQuestCommentRequestDTO)
    case postReply(commentID: Int, dto: CommonQuestReplyRequestDTO)
    case fetchReplies(commentID: Int)
    case patchComment(commentID: Int, dto: CommonQuestReplyRequestDTO)
    case deleteComment(commentID: Int)
}

extension CommentAPI: EndPoint {
    var basePath: String {
        return "/api/v1/comments"
    }
    
    var path: String {
        switch self {
        case .postComment:
            return ""
        case .patchComment(let commentID, _), .deleteComment(let commentID):
            return "/\(commentID)"
        case .postReply(let commentID, _), .fetchReplies(let commentID):
            return "/\(commentID)/replies"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postComment, .postReply:
            return .post
        case .fetchReplies:
            return .get
        case .patchComment:
            return .patch
        case .deleteComment:
            return .delete
        }
    }
    
    var headers: HeaderType {
        switch self {
        case .postComment, .postReply, .fetchReplies, .patchComment, .deleteComment:
            return .withAuth
        }
    }
    
    var parameterEncoding: any Alamofire.ParameterEncoding {
        switch self {
        case .postComment, .postReply, .patchComment:
            return JSONEncoding.default
        case .fetchReplies, .deleteComment:
            return URLEncoding.default
        }
    }
    
    var queryParameters: [String : String]? {
        nil
    }
    
    var bodyParameters: Alamofire.Parameters? {
        switch self {
        case .postComment(let dto):
            return try? dto.toDictionary()
        case .postReply(_, let dto):
            return try? dto.toDictionary()
        case .patchComment(_, let dto):
            return try? dto.toDictionary()
        case .fetchReplies, .deleteComment:
            return nil
        }
    }
}
