//
//  QuestAnswerRepository.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/14/25.
//

import Foundation

struct DefaultQuestAnswerRepository: QuestAnswerInterface {
    func fetchQuestAnswer() async throws -> QuestAnswerEntity {
        return QuestAnswerEntity(
            stepNumber: 2,
            questNumber: 10,
            createdAt: "2025-07-10",
            question: "연애에서 반복됐던 문제 패턴 3가지를 생각해보아요.",
            answer: "내 X는 질투가 너무 많았슨... 그래서 동아리를 할 수가 없었슨.. 특히 솝트처럼 합숙하는 동아린 완전 금지였슨..ㅜㅜ",
            questEmotionState: "자기이해",
            imageUrl: "https://default.image/url.png",
            emotionDescription: "퀘스트를 통해 스스로에 대해 더 잘 알게 되셨네요! 아주 바람직하게 나아가고 있어요."
        )
    }
    
    private let network: NetworkService
    private let userDefaultService: UserDefaultService
    
    init(
        network: NetworkService,
        userDefaultService: UserDefaultService
    ) {
        self.network = network
        self.userDefaultService = userDefaultService
    }
}
