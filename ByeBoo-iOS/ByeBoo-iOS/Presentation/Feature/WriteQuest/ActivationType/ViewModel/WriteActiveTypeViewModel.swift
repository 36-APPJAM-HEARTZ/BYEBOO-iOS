//
//  WriteActiveQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Combine
import Foundation

struct WriteActiveTypeViewModel: ViewModelType {
    
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
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad(let questID):
            getQuestInfo()
        case .didTapCompleteButton:
            postQuestType()
        }
        
    }
}

extension WriteActiveTypeViewModel {
    enum Input {
        case viewDidLoad(quesetID: Int)
        case didTapCompleteButton
    }
    
    struct Output {
        let questInfoResultPublisher: AnyPublisher<Result<QuestInfoEntity, ByeBooError>, Never>
        let didSuccessPostPublisher:  AnyPublisher<Result<Void, ByeBooError>, Never>
    }
}

extension WriteActiveTypeViewModel {
    private func getQuestInfo() {
        Task {
            do {
                let questInfo = try await getQuestInfoUseCase.execute(questID: 1)
                questInfoResultSubject.send(.success(questInfo))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                questInfoResultSubject.send(.failure(error))
            }
        }
    }
    
    private func postQuestType() {
        // TODO: Signed URL 연결
    }
}
