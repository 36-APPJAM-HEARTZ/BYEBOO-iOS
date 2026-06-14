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
    private let likeCountSubject = PassthroughSubject<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>.init()
    
    private let getUserNameUseCase: GetUserNameUseCase
    private let fetchCommonQuestMyAnswersUseCase: FetchCommonQuestMyAnswersUseCase
    private let postCommonQuestLikeUseCase: PostCommonQuestLikeUseCase
    
    
    private(set) var output: Output
    private var commonQuestAnswers: CommonQuestMyAnswersEntity?
    private var answers: [CommonQuestMyAnswerEntity] = []
    private(set) var hasMorePages = true
    private var nextCursor: Int? = nil
    
    private var likeTasks: [Int: Task<Void, Never>] = [:]
    
    init(
        getUserNameUseCase: GetUserNameUseCase,
        fetchCommonQuestMyAnswersUseCase: FetchCommonQuestMyAnswersUseCase,
        postCommonQuestLikeUseCase: PostCommonQuestLikeUseCase
    ) {
        self.getUserNameUseCase = getUserNameUseCase
        self.fetchCommonQuestMyAnswersUseCase = fetchCommonQuestMyAnswersUseCase
        self.postCommonQuestLikeUseCase = postCommonQuestLikeUseCase
        
        self.output = Output(
            namePublisher: nameSubject.eraseToAnyPublisher(),
            answersPublisher: answersSubject.eraseToAnyPublisher(),
            commonQuestLikeCountPublisher: likeCountSubject.eraseToAnyPublisher()
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
    
    private func postCommonQuestLike(answerID: Int) {
        likeTasks[answerID]?.cancel()

        likeTasks[answerID] = Task {
            do {
                let entity = try await postCommonQuestLikeUseCase.execute(answerID: answerID)
                guard !Task.isCancelled else { return }
                likeCountSubject.send(.success((answerID: answerID, entity)))
            } catch {
                guard let error = error as? ByeBooError else {
                    return
                }
                guard !Task.isCancelled else { return }
                likeCountSubject.send(.failure(error))
            }
            likeTasks[answerID] = nil
        }
    }
}

extension CommonQuestMyAnswerViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear
        case scrollAnswer
        case likeButtonDidTap(answerID: Int)
    }
    
    struct Output {
        let namePublisher: AnyPublisher<Result<String, ByeBooError>, Never>
        let answersPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let commonQuestLikeCountPublisher: AnyPublisher<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            getUserName()
            fetchUserCommonQuestAnswers()
        case .scrollAnswer:
            fetchUserCommonQuestAnswers(cursor: nextCursor)
        case .likeButtonDidTap(let answerID):
            postCommonQuestLike(answerID: answerID)
        }
    }
}

extension CommonQuestMyAnswerViewModel {
    
    var answersCount: Int {
        answers.count
    }
    
    func indexOfAnswer(answerID: Int) -> Int? {
        answers.firstIndex { $0.answerID == answerID }
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
