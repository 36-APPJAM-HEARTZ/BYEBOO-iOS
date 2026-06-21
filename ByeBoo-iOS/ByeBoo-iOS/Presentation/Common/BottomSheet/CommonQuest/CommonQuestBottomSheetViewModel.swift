//
//  CommonQuestBottomSheetViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 3/7/26.
//

import Combine
import Foundation

final class CommonQuestBottomSheetViewModel {
    
    private var reportQuestSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private var blockUserSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private var deleteQuestSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    var output: Output {
        Output(
            reportQuestPublisher: reportQuestSubject.eraseToAnyPublisher(),
            blockUserPublisher: blockUserSubject.eraseToAnyPublisher(),
            deleteQuestPublisher: deleteQuestSubject.eraseToAnyPublisher()
        )
    }
    
    private let blockUserUseCase: BlockUserUseCase
    private let reportCommonQuestUseCase: ReportsCommonQuestAnswerUseCase
    private let deleteCommonQuestUseCase: DeleteCommonQuestUseCase
    private let deleteCommentReplyUseCase: DeleteCommentReplyUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(
        blockUserUseCase: BlockUserUseCase,
        reportCommonQuestUseCase: ReportsCommonQuestAnswerUseCase,
        deleteCommonQuestUseCase: DeleteCommonQuestUseCase,
        deleteCommentReplyUseCase: DeleteCommentReplyUseCase
    ) {
        self.blockUserUseCase = blockUserUseCase
        self.reportCommonQuestUseCase = reportCommonQuestUseCase
        self.deleteCommonQuestUseCase = deleteCommonQuestUseCase
        self.deleteCommentReplyUseCase = deleteCommentReplyUseCase
    }
}

extension CommonQuestBottomSheetViewModel: ViewModelType {
    enum Input {
        case block(userID: Int)
        case report(targetID: Int, targetType: CommonQuestTargetType)
        case delete(targetID: Int, targetType: CommonQuestTargetType)
    }
    
    struct Output {
        let reportQuestPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let blockUserPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let deleteQuestPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .block(let userID):
            blockUser(userID: userID)
        case .report(let targetID, let targetType):
            reportCommonQuest(targetID: targetID, targetType: targetType)
        case .delete(let answerID, let targetType):
            if targetType == .COMMENT {
                deleteCommentReply(commentID: answerID)
            } else {
                deleteCommonQuest(answerID: answerID)
            }
        }
    }
}

extension CommonQuestBottomSheetViewModel {
    private func blockUser(userID: Int) {
        Task {
            do {
                try await blockUserUseCase.execute(userID: userID)
                blockUserSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                blockUserSubject.send(.failure(error))
            }
        }
    }
    
    private func reportCommonQuest(targetID: Int, targetType: CommonQuestTargetType) {
        Task {
            do {
                try await reportCommonQuestUseCase.execute(targetID: targetID, targetType: targetType)
                reportQuestSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                reportQuestSubject.send(.failure(error))
            }
        }
    }
    
    private func deleteCommonQuest(answerID: Int) {
        Task {
            do {
                try await deleteCommonQuestUseCase.execute(answerID: answerID)
                deleteQuestSubject.send(.success(()))
            } catch(let error as ByeBooError){
                deleteQuestSubject.send(.failure(error))
            }
        }
    }
    
    private func deleteCommentReply(commentID: Int) {
        Task {
            do {
                try await deleteCommentReplyUseCase.execute(commentID: commentID)
                deleteQuestSubject.send(.success(()))
            } catch(let error as ByeBooError){
                deleteQuestSubject.send(.failure(error))
            }
        }
    }
}
