//
//  AIAnswerViewModel.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 3/3/26.
//

import Combine

final class AIAnswerViewModel {
    
    private(set) var output: Output
    
    private let fetchAIAnswerUseCase: FetchAIAnswerUseCase
    
    private var AIResultSubject = PassthroughSubject<Result<String, ByeBooError>, Never>()
    private var AILoadingSubject = PassthroughSubject<
        Bool, Never>()
    
    private var questID: Int = 1
    private var isAnswerExists: Bool = false
    
    private var fetchAIAnswerTask: Task<Void, Never>?
    
    init(fetchAIAnswerUseCase: FetchAIAnswerUseCase) {
        self.fetchAIAnswerUseCase = fetchAIAnswerUseCase
        
        output = Output(
            AIResultPublisher: AIResultSubject.eraseToAnyPublisher(),
            AILoadingPublisher: AILoadingSubject.eraseToAnyPublisher()
        )
    }
    
}

extension AIAnswerViewModel: ViewModelType {
    enum Input {
        case viewDidLoad(questID: Int, isAIAnswerExists: Bool)
        case viewDidDisappear
    }
    
    struct Output {
        let AIResultPublisher: AnyPublisher<Result<String, ByeBooError>, Never>
        let AILoadingPublisher: AnyPublisher<Bool, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case let .viewDidLoad(questID, isExists):
            self.questID = questID
            self.isAnswerExists = isExists
            
            fetchAIAnswer()
        case .viewDidDisappear:
            cancelTask()
        }
    }
}

extension AIAnswerViewModel {
    private func fetchAIAnswer() {
        fetchAIAnswerTask?.cancel()
        
        fetchAIAnswerTask = Task {
            do {
                AILoadingSubject.send(true)
                
                let answer = try await fetchAIAnswerUseCase.execute(
                    questID: questID,
                    isAnswerExists: isAnswerExists
                ).AIAnswer
                AIResultSubject.send(.success(answer))
                
                AILoadingSubject.send(false)
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                AIResultSubject.send(.failure(error))
                AILoadingSubject.send(false)
            }
        }
    }
    
    private func cancelTask() {
        fetchAIAnswerTask?.cancel()
        fetchAIAnswerTask = nil
    }
}
