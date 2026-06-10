//
//  CommonQuestMyAnswerViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import Combine
import Foundation

final class CommonQuestMyAnswerViewModel {
    
    private let cancellables = Set<AnyCancellable>()
    private let nameSubject = PassthroughSubject<Result<String, ByeBooError>, Never>.init()
    private let answersSubject = PassthroughSubject<Result<Void, ByeBooError>, Never>.init()
    private let getUserNameUseCase: GetUserNameUseCase
    private let fetchCommonQuestMyAnswersUseCase: FetchCommonQuestMyAnswersUseCase
    
    private(set) var output: Output
    private var commonQuestAnswers: CommonQuestMyAnswersEntity?
    private var answers: [CommonQuestMyAnswerEntity] = []
    private(set) var hasMorePages = true
    private var nextCursor: Int? = nil
    
    init(
        getUserNameUseCase: GetUserNameUseCase,
        fetchCommonQuestMyAnswersUseCase: FetchCommonQuestMyAnswersUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        self.fetchCommonQuestMyAnswersUseCase = fetchCommonQuestMyAnswersUseCase
        self.output = Output(
            namePublisher: nameSubject.eraseToAnyPublisher(),
            answersPublisher: answersSubject.eraseToAnyPublisher()
        )
    }
    
    private func getUserName() {
        let name = getUserNameUseCase.execute()
        nameSubject.send(.success(name))
    }
    
    private func fetchUserCommonQuestAnswers(cursor: Int? = nil) {
        Task {
            do {
                if cursor == nil {
                    answers.removeAll()
                }
                
                let result = try await fetchCommonQuestMyAnswersUseCase.execute(cursor: cursor)
                commonQuestAnswers = result
                hasMorePages = result.hasNext
                nextCursor = result.nextCursor
                answers.append(contentsOf: result.answers)
                
                answersSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                answersSubject.send(.failure(error))
            }
        }
    }
}

extension CommonQuestMyAnswerViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear
        case scrollAnswer
    }
    
    struct Output {
        let namePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
        let answersPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            getUserName()
            fetchUserCommonQuestAnswers()
        case .scrollAnswer:
            fetchUserCommonQuestAnswers(cursor: nextCursor)
        }
    }
}

extension CommonQuestMyAnswerViewModel {
    
    var answersCount: Int {
        answers.count
    }
    
    func getAnswer(at index: Int) -> CommonQuestMyAnswerEntity? {
        guard index >= 0 && index < answersCount else {
            return nil
        }
        
        let answer = answers[index]
        let displayDate = DateFormatter.toDetailDate(from: answer.writtenAt).map {
            DateFormatter.toDisplayDateString(from: $0)
        } ?? answer.writtenAt
        
        return .init(
            answerID: answer.answerID,
            writtenAt: displayDate,
            content: answer.content,
            question: answer.question,
            isLiked: answer.isLiked,
            likeCount: answer.likeCount,
            commentCount: answer.commentCount
        )
    }
}
