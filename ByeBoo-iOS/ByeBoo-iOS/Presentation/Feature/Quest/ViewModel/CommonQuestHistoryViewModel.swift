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
    
    private let fetchCommentListSubject: PassthroughSubject<Result<CommonQuestDetailEntity, ByeBooError>, Never> = .init()
    
    private var entity: CommonQuestDetailEntity? = nil
    private var cancellables = Set<AnyCancellable>()
    private(set) var output: Output
    
    init(
        fetchCommonQuestCommentsUseCase: FetchCommonQuestDetailUseCase
    ) {
        self.fetchCommonQuestCommentsUseCase = fetchCommonQuestCommentsUseCase
        
        output = Output(
            fetchCommonQuestDetailPublisher: fetchCommentListSubject.eraseToAnyPublisher()
        )
    }
}

extension CommonQuestHistoryViewModel: ViewModelType {
    enum Input {
        case viewWillAppear(answerID: Int)
    }
    
    struct Output {
        let fetchCommonQuestDetailPublisher: AnyPublisher<Result<CommonQuestDetailEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear(let answerID):
            fetchCommonQuestComments(answerID: answerID)
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
}
