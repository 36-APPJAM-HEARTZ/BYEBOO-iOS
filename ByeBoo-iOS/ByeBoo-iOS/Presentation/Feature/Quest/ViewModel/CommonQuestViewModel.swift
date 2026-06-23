//
//  CommonQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import Combine
import UIKit

final class CommonQuestViewModel {
    
    private var cancellables = Set<AnyCancellable>()
    private let commonQuestSubject = PassthroughSubject<Result<Void, ByeBooError>, Never>.init()
    private let likeCountSubject = PassthroughSubject<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>.init()
    
    private let fetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase
    private let postCommonQuestLikeUseCase: PostCommonQuestLikeUseCase
    private let formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    
    private(set) var output: Output
    private var commonQuest: CommonQuestAnswersEntity?
    private var answers: [CommonQuestAnswerEntity] = []
    private(set) var hasMorePages = true
    private var nextCursor: Int? = nil
    private var currentDate: String = DateFormatter.toAPIDateString(from: .now)
    private var likeTasks: [Int: Task<Void, Never>] = [:]
    
    init(
        fetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase,
        postCommonQuestLikeUseCase: PostCommonQuestLikeUseCase,
        formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    ) {
        self.fetchCommonQuestByDateUseCase = fetchCommonQuestByDateUseCase
        self.postCommonQuestLikeUseCase = postCommonQuestLikeUseCase
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
        self.output = Output(
            commonQuestPublisher: commonQuestSubject.eraseToAnyPublisher(),
            commonQuestLikeCountPublisher: likeCountSubject.eraseToAnyPublisher()
        )
    }
    
    private func fetchCommonQuestByDate(
        date: String,
        cursor: Int? = nil
    ) {
        Task {
            do {
                let result = try await fetchCommonQuestByDateUseCase.execute(
                    date: date,
                    cursor: cursor
                )
                commonQuest = result
                hasMorePages = result.hasNext
                nextCursor = result.nextCursor
                
                if let _ = cursor {
                    answers.append(contentsOf: result.answers)
                } else {
                    answers = result.answers
                }
                
                commonQuestSubject.send(.success(()))
            } catch(let error as ByeBooError) {
                commonQuestSubject.send(.failure(error))
            }
        }
    }
    
    private func postCommonQuestLike(answerID: Int) {
        likeTasks[answerID]?.cancel()

        likeTasks[answerID] = Task {
            do {
                let entity = try await postCommonQuestLikeUseCase.execute(answerID: answerID)
                try Task.checkCancellation()
                likeCountSubject.send(.success((answerID: answerID, entity)))
            } catch is CancellationError {
                ByeBooLogger.debug("Task 취소됨")
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

extension CommonQuestViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear
        case moveDateButtonDidTap(selectedDate: String)
        case scrollAnswer
        case likeButtonDidTap(answerID: Int)
    }
    
    struct Output {
        let commonQuestPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
        let commonQuestLikeCountPublisher: AnyPublisher<Result<(answerID: Int, entity: CommonQuestLikeEntity), ByeBooError>, Never>
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewWillAppear:
            fetchCommonQuestByDate(date: currentDate)
        case .moveDateButtonDidTap(let selectedDate):
            currentDate = selectedDate
            nextCursor = nil
            hasMorePages = true
            fetchCommonQuestByDate(date: selectedDate)
        case .scrollAnswer:
            guard hasMorePages else {
                return
            }
            fetchCommonQuestByDate(date: currentDate, cursor: nextCursor)
        case .likeButtonDidTap(let answerID):
            postCommonQuestLike(answerID: answerID)
        }
    }
}

extension CommonQuestViewModel {
    var question: String {
        commonQuest?.question ?? ""
    }
    
    var questID: Int {
        commonQuest?.questID ?? 1
    }
    
    var answersCount: Int {
        commonQuest?.answerCount ?? 0
    }
    
    var isExistAnswer: Bool {
        commonQuest?.answerCount != 0
    }
    
    var currentAnswerCount: Int {
        answers.count
    }
    
    var isUserAnswered: Bool {
        commonQuest?.isAnswered ?? false
    }

    func getAnswer(at index: Int) -> CommonQuestAnswerEntity? {
        guard index >= 0 && index < answers.count else {
            return nil
        }
        return answers[index]
    }
    
    func getAnswerID(at index: Int) -> Int? {
        guard index >= 0 && index < answers.count else {
            return nil
        }
        return answers[index].answerID
    }

    func indexOfAnswer(answerID: Int) -> Int? {
        answers.firstIndex { $0.answerID == answerID }
    }
    
    func getProfileIcon(at index: Int) -> UIImage? {
        guard index >= 0 && index < answers.count else { return nil }
        return ProfileIcon.image(for: answers[index].profileIcon)
    }
    
    func getWrittenAt(at index: Int) -> String? {
        guard index >= 0 && index < answers.count else { return nil }
        return ServerDateFormatter.shared.relativeTimeString(from: answers[index].writtenAt)
    }
}
