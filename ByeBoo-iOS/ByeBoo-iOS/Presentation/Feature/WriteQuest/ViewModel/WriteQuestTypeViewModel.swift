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
    private let editQuestTypeUseCase: EditQuestTypeUseCase
    private let isValidQuestAnswerUseCase: IsValidQuestAnswerUseCase
    
    private let questInfoResultSubject: PassthroughSubject<Result<QuestInfoEntity, ByeBooError>, Never> = .init()
    private let questInfoWhenEditModeSubject: PassthroughSubject<Result<QuestInfoEntity, ByeBooError>, Never> = .init()
    private let didSuccessPostSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let didSuccessEditSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let isValidTextSubject: PassthroughSubject<Bool, Never> = .init()
    
    init(
        saveQuestTypeUseCase:  SaveQuestTypeUseCase,
        getQuestInfoUseCase: GetQuestInfoUseCase,
        editQuestTypeUseCase: EditQuestTypeUseCase,
        isValidQuestAnswerUseCase: IsValidQuestAnswerUseCase
        
    ){
        self.saveQuestTypeUseCase = saveQuestTypeUseCase
        self.getQuestInfoUseCase = getQuestInfoUseCase
        self.editQuestTypeUseCase = editQuestTypeUseCase
        self.isValidQuestAnswerUseCase = isValidQuestAnswerUseCase
        
        output = Output(
            questInfoResultPublisher: questInfoResultSubject.eraseToAnyPublisher(),
            didSuccessPostPublisher: didSuccessPostSubject.eraseToAnyPublisher(),
            questInfoWhenEditModeResultPublisher: questInfoWhenEditModeSubject.eraseToAnyPublisher(),
            didSuccessEditPublisher: didSuccessEditSubject.eraseToAnyPublisher(),
            isValidTextPublisher: isValidTextSubject.eraseToAnyPublisher()
        )
    }
}

extension WriteQuestionTypeViewModel {
    enum Input {
        case viewDidLoad(quesetID: Int)
        case presentCompleteView(questID: Int, answer: String, emotionState: String?, isEdit: Bool)
        case viewDidLoadWhenEditMode(questID: Int)
        case textFieldEditing(answerText: String, text: String)
    }
    
    struct Output {
        let questInfoResultPublisher: AnyPublisher<Result<QuestInfoEntity, ByeBooError>, Never>
        let didSuccessPostPublisher:  AnyPublisher<Result<Void, ByeBooError>, Never>
        let questInfoWhenEditModeResultPublisher: AnyPublisher<Result<QuestInfoEntity, ByeBooError>, Never>
        let didSuccessEditPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let isValidTextPublisher: AnyPublisher<Bool, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad(let questID), .viewDidLoadWhenEditMode(let questID):
            getQuestInfo(questID: questID)
        case let .presentCompleteView(
            questID,
            answer,
            emotionState,
            isEdit
        ):
            if isEdit {
                editQuestType(questID: questID, answer: answer)
            } else {
                guard let emotionState = emotionState else { return }
                postQuestType(questID: questID, answer: answer, emotionState: emotionState)
            }
        case .textFieldEditing(let answerText, let text):
            isValidText(previousText: answerText, changingText: text)
        }
    }
}

extension WriteQuestionTypeViewModel {
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
    
    private func postQuestType(questID: Int, answer: String, emotionState: String) {
        Task {
            do {
                try await saveQuestTypeUseCase.execute(questID: questID, answer: answer, emotionState: emotionState)
                didSuccessPostSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                didSuccessPostSubject.send(.failure(error as ByeBooError))
                ByeBooLogger.error(error)
            }
        }
    }
    
    private func editQuestType(questID: Int, answer: String) {
        Task {
            do {
                try await editQuestTypeUseCase.execute(questID: questID, answer: answer)
                didSuccessEditSubject.send(.success(()))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                didSuccessEditSubject.send(.failure(error as ByeBooError))
                ByeBooLogger.error(error)
            }
        }
    }
    
    private func isValidText(previousText: String, changingText: String) {
        if isValidQuestAnswerUseCase.execute(previousText: previousText, changingText: changingText) {
            isValidTextSubject.send(true)
        } else {
            isValidTextSubject.send(false)
        }
    }
}
