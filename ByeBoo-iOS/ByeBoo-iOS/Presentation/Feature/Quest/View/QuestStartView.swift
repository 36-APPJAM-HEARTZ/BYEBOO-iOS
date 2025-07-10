//
//  QuestStartView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/9/25.
//

import UIKit

import SnapKit
import Then

final class QuestStartView: BaseView {
    
    private let nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel()
    private let cloverImageView = UIImageView()
    private let descriptionLabel = UILabel()
    let confirmButton = ByeBooButton(titleText: "시작하기", type: .enabled)
    
    override func setStyle() {
        titleLabel.do {
            $0.attributedText = "QUEST JOURNEY\nSTART!".makeTitle(rangedText: "QUEST JOURNEY")
            $0.textAlignment = .center
            $0.font = FontManager.head1Sb24.font
            $0.numberOfLines = 2
        }
        cloverImageView.do {
            $0.image = .clover
            $0.contentMode = .scaleAspectFit
        }
        descriptionLabel.do {
            $0.font = FontManager.body3R16.font
            $0.attributedText = """
                \(nickname)님의 상황에 꼭 맞춘
                감정 직면 여정의 퀘스트 30개를 드릴게요.\n
                제가 드리는 퀘스트와 함께
                이별을 극복해나가요 !
                """.makeTitle(
                    rangedText: "\(nickname)",
                    font: FontManager.body1Sb16.font,
                    baseFont: FontManager.body3R16.font
                )
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
    }
    
    override func setUI() {
        addSubviews(
            titleLabel,
            cloverImageView,
            descriptionLabel,
            confirmButton
        )
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).inset(50.adjustedH)
            $0.centerX.equalToSuperview()
        }
        cloverImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(31.5.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(262.adjustedW)
            $0.height.equalTo(259.adjustedH)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(cloverImageView.snp.bottom).offset(31.5.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(262.adjustedW)
        }
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(326.adjustedW)
            $0.height.equalTo(53.adjustedH)
        }
    }
}
