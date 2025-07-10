//
//  QuestTipViewModel.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import Combine
import Foundation

final class QuestTipViewModel: ViewModelType {
    
    enum InputAction {
       case questTipDidLoad
    }
    
    struct Output {
        let questTipPublisher: AnyPublisher<Result<QuestTipDataEntity, ByeBooError>, Never>
    }
    
    func action(_ trigger: InputAction) {
        // 트리거된게 뷰모델에 전달됨
        // 실제로 여기서 뭐 할거냐
        // subject를 send
        switch trigger {
        case .questTipDidLoad:
            let entity = fetchQuestTips()
            questTipSubject.send(.success(entity))
        }
    }
    
    private var questTipSubject: PassthroughSubject<Result<QuestTipDataEntity, ByeBooError>, Never> = .init()
     
    var output: Output {
        Output(
            questTipPublisher: questTipSubject.eraseToAnyPublisher()
        )
    }
    
    private var cancellables = Set<AnyCancellable>()
    
//    private let useCase: QuestTipUseCase
    
//    init(useCase: QuestTipUseCase) {
//        self.useCase = useCase
//    }
    init() { }

    private func fetchQuestTips() -> QuestTipDataEntity {
        // 서버통신
        // 임의의 dto를 만들고 그걸 엔ㅌ티로 바꿈
        // return 엔티티를 toEntity()

        let data = QuestTipDataEntity(
            step: "감정 정리하기",
            stepNumber: 1,
            questNumber: 10,
            question: "연애에서 반복됐던 문제 패턴 3가지를 생각해보아요.",
            tips: [
                QuestTipEntity(
                    tipStep: 1,
                    tipQuestion: "2번째 퀘스트로 드리는 이유",
                    tipAnswer: "그 사람의 눈치를 보느라 하고 싶은 걸 억누르고 참았던 적이 있지 않나요? 하지만 이제는, 더 이상 맞춰줄 필요 없어요. 내 마음대로, 나답게 생각해도 되는 시간이에요. 억눌렀던 마음을 천천히 꺼내 보면서, 잃어버렸던 ‘진짜 나’를 다시 찾아가봐요."
                ),
                QuestTipEntity(
                    tipStep: 2,
                    tipQuestion: "이런 걸 생각해보면서 작성해 주세요.",
                    tipAnswer: "그 사람이 싫어해서 참았던 말투, 옷차림, 취미는 무엇이었나요? 해보고 싶었지만, 싸우게 될까봐 망설였던 건요?"
                ),
                QuestTipEntity(
                    tipStep: 2,
                    tipQuestion: "이 퀘스트가 끝나면 어떤 변화가 생길까요?",
                    tipAnswer: "관계 속에서 잃었던 나의 일부를 다시 인식하게 돼요. 내가 어떤 부분에서 억눌려 있었는지 알게 돼요. 앞으로 어떤 걸 자유롭게 선택할 수 있는지 알게 돼요."                )
            ]
        )
        return data
    }
}
