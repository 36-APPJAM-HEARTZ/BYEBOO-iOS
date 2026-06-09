//
//  CommonQuestHistoryViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/5/26.
//

import Combine
import Foundation

final class CommonQuestHistoryViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    
    private let fetchCommonQuestCommentsUseCase: FetchCommonQuestDetailUseCase
    
    private let fetchCommentListSubject: PassthroughSubject<Result<CommonQuestDetailEntity, ByeBooError>, Never> = .init()
    
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
    private func fetchCommonQuestComments(answerID: Int) {
        Task {
            do {
                let entity = try await fetchCommonQuestCommentsUseCase.execute(answerID: answerID)
                ByeBooLogger.debug("entity \(entity)")
                fetchCommentListSubject.send(.success(entity))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                fetchCommentListSubject.send(.failure(error))
            }
        }
    }
}
