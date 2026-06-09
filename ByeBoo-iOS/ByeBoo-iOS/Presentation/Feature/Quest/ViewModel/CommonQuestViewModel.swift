//
//  CommonQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import Combine
import UIKit

final class CommonQuestViewModel {
    
    private let cancellables = Set<AnyCancellable>()
    private let commonQuestSubject = PassthroughSubject<Result<Void, ByeBooError>, Never>.init()
    private let fetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase
    private let formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    
    private(set) var output: Output
    private var commonQuest: CommonQuestAnswersEntity?
    private var answers: [CommonQuestAnswerEntity] = []
    private(set) var hasMorePages = true
    private var nextCursor: Int? = nil
    private var currentDate: String = DateFormatter.toAPIDateString(from: .now)
    
    init(
        fetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase,
        formatElapsedTimeUseCase: FormatElapsedTimeUseCase
    ) {
        self.fetchCommonQuestByDateUseCase = fetchCommonQuestByDateUseCase
        self.formatElapsedTimeUseCase = formatElapsedTimeUseCase
        self.output = Output(
            commonQuestPublisher: commonQuestSubject.eraseToAnyPublisher()
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
            } catch {
                commonQuestSubject.send(.failure(error as! ByeBooError))
            }
        }
    }
}

extension CommonQuestViewModel: ViewModelType {
    
    enum Input {
        case viewWillAppear
        case moveDateButtonDidTap(selectedDate: String)
        case scrollAnswer
    }
    
    struct Output {
        let commonQuestPublisher: AnyPublisher<Result<Void, ByeBooError>, Never>
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

    func getProfileIcon(at index: Int) -> UIImage? {
        guard index >= 0 && index < answers.count else { return nil }
        return ProfileIcon.image(for: answers[index].profileIcon)
    }
    
    func getWrittenAt(at index: Int) -> String? {
        guard index >= 0 && index < answers.count else { return nil }
        return formatElapsedTimeUseCase.execute(from: answers[index].writtenAt)
    }
}
