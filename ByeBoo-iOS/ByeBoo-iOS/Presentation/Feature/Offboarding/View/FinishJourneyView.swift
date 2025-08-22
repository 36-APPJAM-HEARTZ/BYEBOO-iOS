//
//  FinishJourneyView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class FinishJourneyView: BaseView {

    private let backgroundImageView = UIImageView()
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let characterImageView = UIImageView()
    let startButton = ByeBooButton(titleText: "새로운 이별 극복 여정 시작하기", type: .enabled)
    let lookBackButton = ByeBooButton(titleText: "완료한 여정 다시보기", type: .sub)
    let backHomeLabel = UILabel()
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgLight
        }
        backgroundView.do {
            $0.backgroundColor = .black80
        }
        titleLabel.do {
            $0.text = "🎉감정 직면 여정을 완료했어요!🎉"
            $0.font = FontManager.sub2Sb18.font
            $0.textColor = .secondary300
            $0.textAlignment = .center
        }
        descriptionLabel.do {
            $0.text =
            """
            무려 30개의 퀘스트를 완료했어요.
            끝까지 포기하지 않고 극복하기 위해 노력한
            하츠핑님이 너무 대단해요.

            지금의 하츠핑님은, 처음보다 성장했을 거예요.

            만약 아직 정리되지 못한 감정이 남아있다면,
            또 다른 새로운 여정을 시작해볼까요?
            """
            $0.numberOfLines = 0
            $0.font = FontManager.body6R14.font
            $0.textColor = .secondary50
            $0.textAlignment = .center
        }
        characterImageView.do {
            $0.image = .cake
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            backgroundView,
            titleLabel,
            descriptionLabel,
            characterImageView,
            startButton,
            lookBackButton
        )
    }

    override func setLayout() {
        let safeArea = safeAreaLayoutGuide

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(18.adjustedH)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(characterImageView.snp.bottom).offset(30.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        lookBackButton.snp.makeConstraints {
            $0.top.equalTo(startButton.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
    }
}
