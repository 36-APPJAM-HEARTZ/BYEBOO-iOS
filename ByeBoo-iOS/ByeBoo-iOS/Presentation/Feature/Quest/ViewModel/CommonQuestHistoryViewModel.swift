//
//  CommonQuestHistoryViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import Combine
import Foundation

final class CommonQuestHistoryViewModel {
    private let fetchCommonQuestCommentsUseCase: FetchCommonQuestDetailUseCase
    private let postCommonQuestLikeUseCase: PostCommonQuestLikeUseCase
    private let postCommentUseCase: PostCommonQuestCommentUseCase
    private let patchCommentUseCase: EditCommentReplyUseCase
    
    private let likeCountSubject = PassthroughSubject<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>.init()
    private let fetchQuestDetailSubject: PassthroughSubject<Result<CommonQuestDetailEntity, ByeBooError>, Never> = .init()
    private let postCommentSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let patchCommentSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    private var entity: CommonQuestDetailEntity? = nil
    private var cancellables = Set<AnyCancellable>()
    private var likeTasks: [Int: Task<Void, Never>] = [:]
    private(set) var output: Output
    
    init(
        fetchCommonQuestCommentsUseCase: FetchCommonQuestDetailUseCase,
        postCommentUseCase: PostCommonQuestCommentUseCase,
        patchCommentUseCase: EditCommentReplyUseCase
        postCommonQuestLikeUseCase: PostCommonQuestLikeUseCase
    ) {
        self.fetchCommonQuestCommentsUseCase = fetchCommonQuestCommentsUseCase
        self.postCommentUseCase = postCommentUseCase
        self.postCommonQuestLikeUseCase = postCommonQuestLikeUseCase
        
        output = Output(
            fetchCommonQuestDetailPublisher: fetchQuestDetailSubject.eraseToAnyPublisher(),
            postCommentPublisher: postCommentSubject.eraseToAnyPublisher(),
            patchCommentPublisher: patchCommentSubject.eraseToAnyPublisher()
            commonQuestLikeCountPublisher: likeCountSubject.eraseToAnyPublisher()
        )
    }
}

extension CommonQuestHistoryViewModel: ViewModelType {
    enum Input {
        case fetchQuestDetail(answerID: Int)
        case postComment(answerID: Int, content: String)
        case likeButtonDidTap(answerID: Int)
        case patchComment(answerID: Int, commentID: Int, content: String)
    }
    
    struct Output {
        let fetchCommonQuestDetailPublisher: AnyPublisher<Result<CommonQuestDetailEntity, ByeBooError>, Never>
        let postCommentPublisher: AnyPublisher<Result<Void, ByeBooError>,Never>
        let patchCommentPublisher: AnyPublisher<Result<Void, ByeBooError>,Never>
        let commonQuestLikeCountPublisher: AnyPublisher<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .fetchQuestDetail(let answerID):
            Task {
                await fetchCommonQuestComments(answerID: answerID)
            }
        case .postComment(let answerID, let content):
            postComment(answerID: answerID, content: content)
        case .likeButtonDidTap(let answerID):
            postCommonQuestLike(answerID: answerID)
        case .patchComment(let answerID, let commentID, let content):
            patchComment(answerID: answerID, commentID: commentID , content: content)
        }
    }
}

extension CommonQuestHistoryViewModel {
    var question: String {
        return entity?.question ?? ""
    }
    
    var detailEntity: CommonQuestAnswerDetailEntity? {
        return entity?.answer
    }
    
    var commentList: [CommonQuestCommentEntity]? {
        return entity?.comments
    }
    
    func getComment(commentID: Int) -> CommonQuestCommentEntity? {
        entity?.comments.first { $0.commentID == commentID }
    }
}

extension CommonQuestHistoryViewModel {
    private func fetchCommonQuestComments(answerID: Int) async {
        do {
            entity = try await fetchCommonQuestCommentsUseCase.execute(answerID: answerID)
            guard let entity else { return }
            ByeBooLogger.debug("entity \(entity)")
            fetchQuestDetailSubject.send(.success(entity))
        } catch {
            guard let error = error as? ByeBooError else { return }
            fetchQuestDetailSubject.send(.failure(error))
        }
    }

    private func postComment(answerID: Int, content: String) {
        Task {
            do {
                _ = try await postCommentUseCase.execute(content: content, targetID: answerID)
                ByeBooLogger.debug("content: \(content)")
                await fetchCommonQuestComments(answerID: answerID)
                postCommentSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                postCommentSubject.send(.failure(error))
            }
        }
    }
    
    private func postCommonQuestLike(answerID: Int) {
        likeTasks[answerID]?.cancel()

        likeTasks[answerID] = Task {
            do {
                let entity = try await postCommonQuestLikeUseCase.execute(answerID: answerID)
                try Task.checkCancellation()
                likeCountSubject.send(.success((answerID, entity)))
            } catch is CancellationError {
                ByeBooLogger.debug("Task 취소됨")
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                guard !Task.isCancelled else { return }
                likeCountSubject.send(.failure(error))
            }
            likeTasks[answerID] = nil
        }
    }
    
    private func patchComment(answerID: Int, commentID: Int, content: String) {
        Task {
            do {
                _ = try await patchCommentUseCase.execute(content: content, targetID: commentID)
                ByeBooLogger.debug("content: \(content)")
                await fetchCommonQuestComments(answerID: answerID)
                patchCommentSubject.send(.success(()))
            }  catch(let error as ByeBooError) {
                patchCommentSubject.send(.failure(error))
            }
        }
    }
}
