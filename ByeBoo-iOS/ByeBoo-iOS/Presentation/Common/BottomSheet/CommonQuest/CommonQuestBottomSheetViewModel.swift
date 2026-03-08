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
    
    var output: Output {
        Output(
            reportQuestPublisher: reportQuestSubject.eraseToAnyPublisher(),
            blockUserPublisher: blockUserSubject.eraseToAnyPublisher()
        )
    }
    
    private let blockUserUseCase: BlockUserUseCase
    private let reportCommonQuestUseCase: ReportsCommonQuestAnswerUseCase
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        blockUserUseCase: BlockUserUseCase,
        reportCommonQuestUseCase: ReportsCommonQuestAnswerUseCase
    ) {
        self.blockUserUseCase = blockUserUseCase
        self.reportCommonQuestUseCase = reportCommonQuestUseCase
    }
    
}

extension CommonQuestBottomSheetViewModel: ViewModelType {
    enum Input {
        case block(userID: Int)
        case report(answerID: Int)
    }
    
    struct Output {
        let reportQuestPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let blockUserPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .block(let userID):
            blockUser(userID: userID)
        case .report(let answerID):
            reportCommonQuest(answerID: answerID)
        }
    }
}

extension CommonQuestBottomSheetViewModel {
    private func blockUser(userID: Int) {
        Task {
            do {
                try await blockUserUseCase.execute(userID: userID)
                blockUserSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                blockUserSubject.send(.failure(error))
            }
        }
    }
    
    private func reportCommonQuest(answerID: Int) {
        Task {
            do {
                try await reportCommonQuestUseCase.execute(answerID: answerID)
                reportQuestSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                ByeBooLogger.error(error as ByeBooError)
                reportQuestSubject.send(.failure(error))
            }
        }
    }
}
