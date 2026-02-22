//
//  CommonQuestViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import UIKit

final class CommonQuestViewModel {
    
    private var commonQuest: CommonQuestAnswersEntity?
    private let fetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase
    
    init(fetchCommonQuestByDateUseCase: FetchCommonQuestByDateUseCase) {
        self.fetchCommonQuestByDateUseCase = fetchCommonQuestByDateUseCase
    }
    
    enum Input {
        case viewDidLoad
        case moveDateButtonDidTap(selectedDate: String)
    }
    
    struct Output {
        let commonQuestAnswers: CommonQuestAnswersEntity
    }
    
    func action(_ trigger: Input) -> Output {
        let result: CommonQuestAnswersEntity = .stub()
        commonQuest = result
        return .init(commonQuestAnswers: result)
    }
}

extension CommonQuestViewModel {
    
    private enum ProfileIcon: String, CaseIterable {
        case sad = "SAD"
        case selfUnderstanding = "SELF_UNDERSTANDING"
        case soso = "SO_SO"
        case relieved = "RELIEVED"
        
        var image: UIImage {
            switch self {
            case .sad:
                return .sadnessBadge
            case .selfUnderstanding:
                return .selfUnderstandingBadge
            case .soso:
                return .sosoBadge
            case .relieved:
                return .relievedBadge
            }
        }
    }
    
    var question: String {
        commonQuest?.question ?? ""
    }
    
    var answersCount: Int {
        commonQuest?.answerCount ?? 0
    }
    
    var isExistAnswer: Bool {
        commonQuest?.answerCount != 0
    }
    
    func getAnswer(at index: Int) -> CommonQuestAnswerEntity {
        commonQuest?.answers[index] ?? .stub()
    }
    
    func getProfileIcon(at index: Int) -> UIImage? {
        let iconString = commonQuest?.answers[index].profileIcon
        let profileIcon = ProfileIcon.allCases
            .first { $0.rawValue == iconString }?
            .image
        return profileIcon
    }
    
    func getWrittenAt(at index: Int) -> Date {
        commonQuest?.answers[index].writtenAt ?? .now
    }
}
