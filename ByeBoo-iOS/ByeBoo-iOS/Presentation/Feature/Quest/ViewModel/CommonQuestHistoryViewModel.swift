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
    
    private let fetchCommentListSubject: PassthroughSubject<Result<CommonQuestDetailEntity, ByeBooError>, Never> = .init()
    private let likeCountSubject = PassthroughSubject<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>.init()
    
    private var entity: CommonQuestDetailEntity? = nil
    private var cancellables = Set<AnyCancellable>()
    private var likeTasks: [Int: Task<Void, Never>] = [:]
    private(set) var output: Output
    
    init(
        fetchCommonQuestCommentsUseCase: FetchCommonQuestDetailUseCase,
        postCommonQuestLikeUseCase: PostCommonQuestLikeUseCase
    ) {
        self.fetchCommonQuestCommentsUseCase = fetchCommonQuestCommentsUseCase
        self.postCommonQuestLikeUseCase = postCommonQuestLikeUseCase
        
        output = Output(
            fetchCommonQuestDetailPublisher: fetchCommentListSubject.eraseToAnyPublisher(),
            commonQuestLikeCountPublisher: likeCountSubject.eraseToAnyPublisher()
        )
    }
}

extension CommonQuestHistoryViewModel: ViewModelType {
    enum Input {
        case viewWillAppear(answerID: Int)
        case likeButtonDidTap(answerID: Int)
    }
    
    struct Output {
        let fetchCommonQuestDetailPublisher: AnyPublisher<Result<CommonQuestDetailEntity, ByeBooError>, Never>
        let commonQuestLikeCountPublisher: AnyPublisher<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear(let answerID):
            fetchCommonQuestComments(answerID: answerID)
        case .likeButtonDidTap(let answerID):
            postCommonQuestLike(answerID: answerID)
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
}

extension CommonQuestHistoryViewModel {
    private func fetchCommonQuestComments(answerID: Int) {
        Task {
            do {
                entity = try await fetchCommonQuestCommentsUseCase.execute(answerID: answerID)
                guard let entity else { return }
                ByeBooLogger.debug("entity \(entity)")
                fetchCommentListSubject.send(.success(entity))
            } catch(let error as ByeBooError) {
                fetchCommentListSubject.send(.failure(error))
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
}
