//
//  CommonQuestReplyViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/8/26.
//

import Foundation

import Combine

final class CommonQuestReplyViewModel {
    
    private let fetchRepliesUseCase: FetchCommonQuestRepliesUseCase
    private let postReplyUseCase: PostCommonQuestReplyUseCase
    private let patchReplyUseCase: EditCommentReplyUseCase
    
    private let fetchRepliesSubject: PassthroughSubject<Result<CommonQuestReplyListEntity, ByeBooError>, Never> = .init()
    private let postReplySubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let patchReplySubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    private var cancellables = Set<AnyCancellable>()
    private(set) var output: Output

    private var comment: CommonQuestCommentEntity?
    private var replies: [CommonQuestCommentEntity] = []
    
    init(
        fetchRepliesUseCase: FetchCommonQuestRepliesUseCase,
        postReplyUseCase: PostCommonQuestReplyUseCase,
        patchReplyUseCase: EditCommentReplyUseCase
    ) {
        self.fetchRepliesUseCase = fetchRepliesUseCase
        self.postReplyUseCase = postReplyUseCase
        self.patchReplyUseCase = patchReplyUseCase
        
        output = Output(
            fetchReplyListPublisher: fetchRepliesSubject.eraseToAnyPublisher(),
            postReplyPublisher: postReplySubject.eraseToAnyPublisher(),
            patchReplyPublisher: patchReplySubject.eraseToAnyPublisher()
        )
    }
    
    func getCommentContent() -> CommonQuestCommentEntity {
        return CommonQuestCommentEntity.toCommentStub()
    }
    
    func getReplyList() -> [CommonQuestCommentEntity] {
        return CommonQuestCommentEntity.toReplyListStub()
    }

    func setComment(_ comment: CommonQuestCommentEntity) {
        self.comment = comment
    }

    func getComment(commentID: Int) -> CommonQuestCommentEntity? {
        if comment?.commentID == commentID { return comment }
        return replies.first { $0.commentID == commentID }
    }
}

extension CommonQuestReplyViewModel {
    enum Input {
        case fetchReplyList(commentID: Int)
        case postReply(commentID: Int, content: String)
        case editReply(commentID: Int, editingCommentID: Int, content: String)
    }
    
    struct Output {
        let fetchReplyListPublisher: AnyPublisher<Result<CommonQuestReplyListEntity, ByeBooError>, Never>
        let postReplyPublisher: AnyPublisher<Result<Void, ByeBooError>,Never>
        let patchReplyPublisher: AnyPublisher<Result<Void, ByeBooError>,Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .fetchReplyList(let commentID):
            Task {
                await fetchReplyList(commentID: commentID)
            }
        case .postReply(let commentID, let content):
            postReply(commentID: commentID, content: content)
        case .editReply(let commentID, let editingCommentID, let content):
            patchReply(commentID: commentID, editingCommentID: editingCommentID, content: content)
        }
    }
}

extension CommonQuestReplyViewModel {
    private func fetchReplyList(commentID: Int) async {
        do {
            let result = try await fetchRepliesUseCase.execute(commentID: commentID)
            replies = result.replies
            ByeBooLogger.debug("답글 목록 \(result)")
            fetchRepliesSubject.send(.success(result))
        } catch {
            guard let error = error as? ByeBooError else { return }
            fetchRepliesSubject.send(.failure(error))
        }
    }
    
    private func postReply(commentID: Int, content: String) {
        Task {
            do {
                _ = try await postReplyUseCase.execute(content: content, commentID: commentID )
                ByeBooLogger.debug("답글 달기 성공")
                await fetchReplyList(commentID: commentID)
                postReplySubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else { return }
                postReplySubject.send(.failure(error))
            }
        }
    }
    
    private func patchReply(commentID: Int, editingCommentID: Int, content: String) {
        Task {
            do {
                _ = try await patchReplyUseCase.execute(content: content, targetID: editingCommentID)
                await fetchReplyList(commentID: commentID)
                patchReplySubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else { return }
                patchReplySubject.send(.failure(error))
            }
        }
    }
}
