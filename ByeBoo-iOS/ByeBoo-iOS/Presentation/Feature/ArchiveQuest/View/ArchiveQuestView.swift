//
//  ArchiveQuestView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import Then
import SnapKit

final class ArchiveQuestView: BaseView {
 
    private let headerView = ArchiveQuestHeaderView(
        type: .archive,
        stepNumber: 1,
        questNumber: 2,
        date: "2025. 07. 02",
        questTitle: "그 사람이 싫어하기에 내가 포기해야만 했던 일은 무엇일까?"
    )
    private let thinkView = ThinkView(descriptionText: "내 X는 질투가 너무 많았다 어쩌구 저쩌구 그래서 동아리를 할 수가 없엇슨... 특히 솝트처럼 합숙하는 동아리는 완전 금지엿슨 ㅠㅠ ")
    private let feelView = FeelView(emotionType: "자기이해", descriptionText: "오늘은 퀘스트를 통해 스스로에 대해 더 잘 알게 되셨네요! 아주 바람직하게 나아가고 있어요.")

    override func setStyle() {
        backgroundColor = .grayscale900
    }
    
    override func setUI() {
        addSubviews(
            headerView,
            thinkView,
            feelView
        )
    }
    
    override func setLayout() {
        let safeArea = safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.horizontalEdges.equalToSuperview()
        }
        
        thinkView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        
        feelView.snp.makeConstraints {
            $0.top.equalTo(thinkView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
}
