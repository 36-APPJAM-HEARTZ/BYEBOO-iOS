//
//  WriteQuestionTypeViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/7/25.
//

import Combine
import Foundation

struct WriteQuestionTypeViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    
    private let saveQuestTypeUseCase: SaveQuestTypeUseCase
    private let getQuestInfoUseCase: GetQuestInfoUseCase
    
    private let questInfoResultSubject: PassthroughSubject<Result<QuestInfoEntity, ByeBooError>, Never> = .init()
    private let didSuccessPostSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    init(
        saveQuestTypeUseCase:  SaveQuestTypeUseCase,
        getQuestInfoUseCase: GetQuestInfoUseCase
        
    ){
        self.saveQuestTypeUseCase = saveQuestTypeUseCase
        self.getQuestInfoUseCase = getQuestInfoUseCase
        
        output = Output(
            questInfoResultPublisher: questInfoResultSubject.eraseToAnyPublisher(),
            didSuccessPostPublisher: didSuccessPostSubject.eraseToAnyPublisher()
        )
    }
}

extension WriteQuestionTypeViewModel {
    enum Input {
        case viewDidLoad(quesetID: Int)
        case presentCompleteView(questID: Int, answer: String, emotionState: String)
    }
    
    struct Output {
        let questInfoResultPublisher: AnyPublisher<Result<QuestInfoEntity, ByeBooError>, Never>
        let didSuccessPostPublisher:  AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad(let questID):
            getQuestInfo(questID: questID)
        case .presentCompleteView(
            let questID,
            let answer,
            let emotionState
        ):
            postQuestType(questID: questID, answer: answer, emotionState: emotionState)
        }
    }
}

extension WriteQuestionTypeViewModel {
    private func getQuestInfo(questID: Int) {
        Task {
            do {
                let questInfo = try await getQuestInfoUseCase.execute(questID: 31)
                questInfoResultSubject.send(.success(questInfo))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                questInfoResultSubject.send(.failure(error))
            }
        }
    }
    
    private func postQuestType(questID: Int, answer: String, emotionState: String) {
        Task {
            do {
                let _ = try await saveQuestTypeUseCase.execute(questID: 31, answer: answer, emotionState: emotionState)
                didSuccessPostSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                didSuccessPostSubject.send(.failure(error as ByeBooError))
                ByeBooLogger.debug("네트워크 호출 실패")
            }
        }
    }
}
