//
//  CommonQuestMyAnswerViewModel.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import Foundation

final class CommonQuestMyAnswerViewModel {
    
    private var answerRecords: [AnswerRecord] = []
    private let getUserNameUseCase: GetUserNameUseCase
    
    struct AnswerRecord {
        let question: String
        let answer: String
        let writtenAt: Date
    }
    
    var dataCount: Int {
        answerRecords.count
    }
    
    init(getUserNameUseCase: GetUserNameUseCase) {
        self.getUserNameUseCase = getUserNameUseCase
        answerRecords = Self.stub()
    }
    
    func getUserName() -> String {
        getUserNameUseCase.execute()
    }
    
    func getRecord(at index: Int) -> AnswerRecord? {
        guard index >= 0 && index < answerRecords.count else {
            return nil
        }
        return answerRecords[index]
    }
    
    private static func stub() -> [AnswerRecord] {
        return [
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 지 벌써 일주일이 지났습니다. 처음에는 실감이 안 나서 눈물조차 나오지 않았어요. 그저 멍하니 천장만 바라보며 시간을 보냈습니다. 그런데 오늘 아침, 습관적으로 휴대폰을 확인하다가 더 이상 '굿모닝' 인사를 보낼 사람이 없다는 사실을 깨닫고 그제야 무너져 내렸습니다. 밥알이 모래알 같아서 잘 넘어가지도 않네요. 친구들은 시간이 약이라고, 더 좋은 사람 만날 거라고 위로하지만 지금 당장은 그 어떤 말도 귀에 들어오지 않습니다.",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 지 벌써 일주일이 지났습니다. 처음에는 실감이 안 나서 눈물조차 나오지 않았어요. 그저 멍하니 천장만 바라보며 시간을 보냈습니다. 그런데 오늘 아침, 습관적으로 휴대폰을 확인하다가 더 이상 '굿모닝' 인사를 보낼 사람이 없다는 사실을 깨닫고 그제야 무너져 내렸습니다. 밥알이 모래알 같아서 잘 넘어가지도 않네요. 친구들은 시간이 약이라고, 더 좋은 사람 만날 거라고 위로하지만 지금 당장은 그 어떤 말도 귀에 들어오지 않습니다.",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 지 벌써 일주일이 지났습니다. 처음에는 실감이 안 나서 눈물조차 나오지 않았어요. 그저 멍하니 천장만 바라보며 시간을 보냈습니다. 그런데 오늘 아침, 습관적으로 휴대폰을 확인하다가 더 이상 '굿모닝' 인사를 보낼 사람이 없다는 사실을 깨닫고 그제야 무너져 내렸습니다. 밥알이 모래알 같아서 잘 넘어가지도 않네요. 친구들은 시간이 약이라고, 더 좋은 사람 만날 거라고 위로하지만 지금 당장은 그 어떤 말도 귀에 들어오지 않습니다.",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 지 벌써 일주일이 지났습니다. 처음에는 실감이 안 나서 눈물조차 나오지 않았어요. 그저 멍하니 천장만 바라보며 시간을 보냈습니다. 그런데 오늘 아침, 습관적으로 휴대폰을 확인하다가 더 이상 '굿모닝' 인사를 보낼 사람이 없다는 사실을 깨닫고 그제야 무너져 내렸습니다. 밥알이 모래알 같아서 잘 넘어가지도 않네요. 친구들은 시간이 약이라고, 더 좋은 사람 만날 거라고 위로하지만 지금 당장은 그 어떤 말도 귀에 들어오지 않습니다.",
                writtenAt: .now
            ),
            .init(
                question: "이별 후 제일 힘들었던 순간은?",
                answer: "헤어진 지 벌써 일주일이 지났습니다. 처음에는 실감이 안 나서 눈물조차 나오지 않았어요. 그저 멍하니 천장만 바라보며 시간을 보냈습니다. 그런데 오늘 아침, 습관적으로 휴대폰을 확인하다가 더 이상 '굿모닝' 인사를 보낼 사람이 없다는 사실을 깨닫고 그제야 무너져 내렸습니다. 밥알이 모래알 같아서 잘 넘어가지도 않네요. 친구들은 시간이 약이라고, 더 좋은 사람 만날 거라고 위로하지만 지금 당장은 그 어떤 말도 귀에 들어오지 않습니다.",
                writtenAt: .now
            )
        ]
    }
}
