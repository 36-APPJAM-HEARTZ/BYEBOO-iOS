//
//  WriteActiveQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/13/25.
//

import Combine
import Foundation
import UIKit

struct WriteActiveTypeViewModel: ViewModelType {
    
    private var cancellables = Set<AnyCancellable>()
    
    private(set) var output: Output
    
    private let saveQuestTypeUseCase: SaveQuestTypeUseCase
    private let saveActiveQuestUseCase: SaveQuestActiveUseCase
    private let getQuestInfoUseCase: GetQuestInfoUseCase
    
    private let questInfoResultSubject: PassthroughSubject<Result<QuestInfoEntity, ByeBooError>, Never> = .init()
    private let questActiveResultSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let didSuccessPostSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    init(
        saveQuestTypeUseCase:  SaveQuestTypeUseCase,
        saveActiveTypeUseCase: SaveQuestActiveUseCase,
        getQuestInfoUseCase: GetQuestInfoUseCase
        
    ){
        self.saveQuestTypeUseCase = saveQuestTypeUseCase
        self.saveActiveQuestUseCase = saveActiveTypeUseCase
        self.getQuestInfoUseCase = getQuestInfoUseCase
        
        output = Output(
            questInfoResultPublisher: questInfoResultSubject.eraseToAnyPublisher(),
            didSuccessPostPublisher: didSuccessPostSubject.eraseToAnyPublisher()
        )
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad(let questID):
            getQuestInfo(questID: questID)
        case .didTapCompleteButton(
            let questID,
            let answer,
            let emotionState,
            let image,
            let imageKey
        ):
            postActiveType(
                questID: questID,
                answer: answer,
                emotionState: emotionState,
                image: image,
                imageKey: imageKey
            )
        }
    }
}

extension WriteActiveTypeViewModel {
    enum Input {
        case viewDidLoad(quesetID: Int)
        case didTapCompleteButton(
            questID: Int,
            answer: String,
            emotionState: String,
            image: UIImage,
            imageKey: String
        )
    }
    
    struct Output {
        let questInfoResultPublisher: AnyPublisher<Result<QuestInfoEntity, ByeBooError>, Never>
        let didSuccessPostPublisher:  AnyPublisher<Result<Void, ByeBooError>, Never>
    }
}

extension WriteActiveTypeViewModel {
    private func getQuestInfo(questID: Int) {
        Task {
            do {
                let questInfo = try await getQuestInfoUseCase.execute(questID: questID)
                questInfoResultSubject.send(.success(questInfo))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                questInfoResultSubject.send(.failure(error))
            }
        }
    }
    
    private func postActiveType(
        questID: Int,
        answer: String,
        emotionState: String,
        image: UIImage,
        imageKey: String
    ) {
        Task {
            do {
                ByeBooLogger.debug("data size: \(image.size)")
                if let jpegImage = image.jpegData(compressionQuality: 0.5) {
                    
                    try await saveActiveQuestUseCase.execute(
                        questID: questID,
                        answer: answer,
                        emotionState: emotionState,
                        image: jpegImage,
                        imageKey: imageKey
                    )
                    didSuccessPostSubject.send(.success(()))
                } else {
                    ByeBooLogger.error(ByeBooError.noData)
                }
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                didSuccessPostSubject.send(.failure(error))
            }
        }
    }
}
