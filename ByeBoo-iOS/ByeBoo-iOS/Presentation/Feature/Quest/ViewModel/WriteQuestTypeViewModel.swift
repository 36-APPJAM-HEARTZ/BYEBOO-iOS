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
    private let saveCommonQuestUseCase: SaveCommonQuestUseCase
    private let isForbiddenWordUseCase: IsForbiddenWordUseCase
    private let updateCommonQuestUseCase: UpdateCommonQuestUseCase
    
    private let questInfoResultSubject: PassthroughSubject<Result<QuestInfoEntity, ByeBooError>, Never> = .init()
    private let questInfoWhenEditModeSubject: PassthroughSubject<Result<QuestInfoEntity, ByeBooError>, Never> = .init()
    private let didSuccessPostSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let didSuccessEditSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let isValidTextSubject: PassthroughSubject<Bool, Never> = .init()
    private let isForbiddenWordSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    private let didSucessUpdateSubject: PassthroughSubject<Result<Void, ByeBooError>, Never> = .init()
    
    init(
        saveQuestTypeUseCase:  SaveQuestTypeUseCase,
        getQuestInfoUseCase: GetQuestInfoUseCase,
        editQuestTypeUseCase: EditQuestTypeUseCase,
        isValidQuestAnswerUseCase: IsValidQuestAnswerUseCase,
        saveCommonQuestUseCase: SaveCommonQuestUseCase,
        isForbiddenWordUseCase: IsForbiddenWordUseCase,
        updateCommonQuestUseCase: UpdateCommonQuestUseCase
    ){
        self.saveQuestTypeUseCase = saveQuestTypeUseCase
        self.getQuestInfoUseCase = getQuestInfoUseCase
        self.editQuestTypeUseCase = editQuestTypeUseCase
        self.isValidQuestAnswerUseCase = isValidQuestAnswerUseCase
        self.saveCommonQuestUseCase = saveCommonQuestUseCase
        self.isForbiddenWordUseCase = isForbiddenWordUseCase
        self.updateCommonQuestUseCase = updateCommonQuestUseCase
        
        output = Output(
            questInfoResultPublisher: questInfoResultSubject.eraseToAnyPublisher(),
            didSuccessPostPublisher: didSuccessPostSubject.eraseToAnyPublisher(),
            questInfoWhenEditModeResultPublisher: questInfoWhenEditModeSubject.eraseToAnyPublisher(),
            didSuccessEditPublisher: didSuccessEditSubject.eraseToAnyPublisher(),
            isValidTextPublisher: isValidTextSubject.eraseToAnyPublisher(),
            isForbiddenWordPublisher: isForbiddenWordSubject.eraseToAnyPublisher(),
            didSucessUpdatePublisher: didSucessUpdateSubject.eraseToAnyPublisher()
        )
    }
}

extension WriteQuestionTypeViewModel {
    enum Input {
        case viewDidLoad(quesetID: Int)
        case saveQuest(
            questID: Int,
            answer: String,
            emotionState: String?,
            isEdit: Bool,
            isCommonQuest: Bool,
            answerID: Int?
        )
        case viewDidLoadWhenEditMode(questID: Int)
        case textFieldEditing(answerText: String, text: String)
    }
    
    struct Output {
        let questInfoResultPublisher: AnyPublisher<Result<QuestInfoEntity, ByeBooError>, Never>
        let didSuccessPostPublisher:  AnyPublisher<Result<Void, ByeBooError>, Never>
        let questInfoWhenEditModeResultPublisher: AnyPublisher<Result<QuestInfoEntity, ByeBooError>, Never>
        let didSuccessEditPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let isValidTextPublisher: AnyPublisher<Bool, Never>
        let isForbiddenWordPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let didSucessUpdatePublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad(let questID), .viewDidLoadWhenEditMode(let questID):
            getQuestInfo(questID: questID)
        case let .saveQuest(
            questID,
            answer,
            emotionState,
            isEdit,
            isCommonQuest,
            answerID
        ):
            if isCommonQuest && isForbiddenWordUseCase.execute(word: answer) {
                isForbiddenWordSubject.send(.failure(.questViolation))
                return
            }
            
            if isCommonQuest {
                if isEdit {
                    updateCommonQuest(answerID: answerID, answer: answer)
                    return
                }
                saveCommonQuest(questID: questID, answer: answer)
                return
            }
            
            if isEdit {
                editQuestType(questID: questID, answer: answer)
                return
            }
            
            guard let emotionState else { return }
            postQuestType(questID: questID, answer: answer, emotionState: emotionState)
            
            
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
            } catch(let error as ByeBooError) {
                questInfoResultSubject.send(.failure(error))
            }
        }
    }
    
    private func postQuestType(questID: Int, answer: String, emotionState: String) {
        Task {
            do {
                try await saveQuestTypeUseCase.execute(questID: questID, answer: answer, emotionState: emotionState)
                didSuccessPostSubject.send(.success(()))
            } catch(let error as ByeBooError) {
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
            } catch(let error as ByeBooError) {
                didSuccessEditSubject.send(.failure(error as ByeBooError))
                ByeBooLogger.error(error)
            }
        }
    }
    
    private func saveCommonQuest(questID: Int, answer: String) {
        Task {
            do {
                try await saveCommonQuestUseCase.execute(questID: questID, answer: answer)
                didSuccessPostSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                didSuccessPostSubject.send(.failure(error as ByeBooError))
                ByeBooLogger.error(error)
            }
        }
    }
    
    private func isValidText(previousText: String, changingText: String) {
        let isValidText: Bool = isValidQuestAnswerUseCase.executeWhenQuestionType(previousText: previousText, changingText: changingText)
        isValidTextSubject.send(isValidText)
    }
    
    private func updateCommonQuest(answerID: Int?, answer: String) {
        guard let answerID else {
            ByeBooLogger.error(ByeBooError.noData)
            return
        }
        
        Task {
            do {
                try await updateCommonQuestUseCase.execute(answerID: answerID, answer: answer)
                didSucessUpdateSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                didSuccessPostSubject.send(.failure(error as ByeBooError))
                ByeBooLogger.error(error)
            }
        }
    }
}
