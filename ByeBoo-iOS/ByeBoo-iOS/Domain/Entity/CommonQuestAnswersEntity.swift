//
//  CommonQuestAnswersEntity.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/17/26.
//

import Foundation

struct CommonQuestAnswersEntity {
    let question: String
    let questID: Int
    let answerCount: Int
    let isAnswered: Bool
    let hasNext: Bool
    let nextCursor: Int?
    let answers: [CommonQuestAnswerEntity]
}

struct CommonQuestAnswerEntity {
    let answerID: Int
    let writer: String
    let profileIcon: String
    let writtenAt: String
    let content: String
}

extension CommonQuestAnswersEntity {
    
    static let profileIcons = ["SAD", "SO_SO", "RELIEVED", "SELF_UNDERSTANDING"]
    
    static let allAnswers: [CommonQuestAnswerEntity] = (1...30).map {
        CommonQuestAnswerEntity(
            answerID: $0,
            writer: "유저\($0)",
            profileIcon: profileIcons[$0 % 4],
            writtenAt: Date.now.toString(),
            content: "\($0)번째 테스트 답변"
        )
    }
    
    static func emptyAnswerStub() -> Self {
        .init(
            question: "Question",
            questID: 1,
            answerCount: allAnswers.count,
            isAnswered: true,
            hasNext: false,
            nextCursor: nil,
            answers: []
        )
    }
}

extension CommonQuestAnswerEntity {
    static func stub() -> Self {
        .init(
            answerID: 1,
            writer: "장원영",
            profileIcon: "SO_SO",
            writtenAt: "2025-10-12",
            content: "헤어진 지 벌써 일주일이 지났습니다. 처음에는 실감이 안 나서 눈물조차 나오지 않았어요. 그저 멍하니 천장만 바라보며 시간을 보냈습니다. 그런데 오늘 아침, 습관적으로 휴대폰을 확인하다가 더 이상 '굿모닝' 인사를 보낼 사람이 없다는 사실을 깨닫고 그제야 무너져 내렸습니다. 밥알이 모래알 같아서 잘 넘어가지도 않네요. 친구들은 시간이 약이라고, 더 좋은 사람 만날 거라고 위로하지만 지금 당장은 그 어떤 말도 귀에 들어오지 않습니다."
        )
    }
}
