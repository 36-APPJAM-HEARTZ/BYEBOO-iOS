//
//  CommonQuestMyAnswerViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import Foundation

final class CommonQuestMyAnswerViewModel {
    
    private let getUserNameUseCase: GetUserNameUseCase
    private var answerRecords: [AnswerRecord] = []
    
    init(getUserNameUseCase: GetUserNameUseCase) {
        self.getUserNameUseCase = getUserNameUseCase
        answerRecords = CommonQuestMyAnswerViewModel.stub()
    }
    
    struct AnswerRecord {
        let question: String
        let answer: String
        let writtenAt: Date
    }
    
    var dataCount: Int {
        answerRecords.count
    }
    
    func getRecord(at index: Int) -> AnswerRecord? {
        guard index >= 0 && index < answerRecords.count else {
            return nil
        }
        return answerRecords[index]
    }
    
    func getUserName() -> String {
        getUserNameUseCase.execute()
    }
    
    private static func stub() -> [AnswerRecord] {
        return [
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 첫날 밤이었어요. 혼자 집에 있는데 갑자기 모든 게 현실로 다가왔고, 이제 정말 끝났",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 첫날 밤이었어요. 혼자 집에 있는데 갑자기 모든 게 현실로 다가왔고, 이제 정말 끝났",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 첫날 밤이었어요. 혼자 집에 있는데 갑자기 모든 게 현실로 다가왔고, 이제 정말 끝났",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 첫날 밤이었어요. 혼자 집에 있는데 갑자기 모든 게 현실로 다가왔고, 이제 정말 끝났",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 첫날 밤이었어요. 혼자 집에 있는데 갑자기 모든 게 현실로 다가왔고, 이제 정말 끝났",
                writtenAt: .now
            )
        ]
    }
}
