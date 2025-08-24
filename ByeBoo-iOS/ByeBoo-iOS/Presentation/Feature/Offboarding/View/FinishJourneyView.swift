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
    private let currentTextLabel = UILabel()
    private let nextTextLabel = UILabel()
    private let characterImageView = UIImageView()
    let startButton = ByeBooButton(titleText: "새로운 이별 극복 여정 시작하기", type: .enabled)
    let lookBackButton = ByeBooButton(titleText: "완료한 여정 다시보기", type: .sub)
    let backHomeLabel = UILabel()
    
    private let animationText: [String] = [
        "무려 30개의 퀘스트를 완료했어요.\n끝까지 포기하지 않고 극복하기 위해 노력한\n하츠핑님이 너무 대단해요.",
        "지금의 하츠핑님은, 처음보다 성장했을 거예요.",
        "만약 아직 정리되지 못한 감정이 남아있다면,\n또 다른 새로운 여정을 시작해볼까요?"
    ]
    
    private var paragraphIndex: Int = 0
    
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
        currentTextLabel.do {
            $0.text = animationText[0]
            $0.numberOfLines = 0
            $0.font = FontManager.body6R14.font
            $0.textColor = .secondary50
            $0.textAlignment = .center
        }
        nextTextLabel.do {
            $0.text = animationText[1]
            $0.numberOfLines = 0
            $0.font = FontManager.cap2R12.font
            $0.textColor = .secondary5050
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
            currentTextLabel,
            nextTextLabel,
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
        currentTextLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        nextTextLabel.snp.makeConstraints {
            $0.top.equalTo(currentTextLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(154.adjustedH)
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

extension FinishJourneyView {
    
    func startParagraphAnimation() {
        paragraphIndex = 0
        currentTextLabel.text = animationText[paragraphIndex]
        nextParagraphAnimation()
    }
    
    private func nextParagraphAnimation() {
        guard paragraphIndex + 1 < animationText.count else { return }
        
        paragraphIndex += 1
        let nextText = animationText[paragraphIndex]
        
        nextTextLabel.text = nextText
        self.nextTextLabel.alpha = 1
        nextTextLabel.transform = .identity
        
        UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseInOut], animations: {
            self.currentTextLabel.transform = CGAffineTransform(translationX: 0, y: -20)
            self.currentTextLabel.alpha = 0
            
            self.nextTextLabel.transform = CGAffineTransform(translationX: 0, y: -20)
        }, completion: { _ in
            self.currentTextLabel.text = nextText
            self.currentTextLabel.alpha = 1
            self.currentTextLabel.transform = .identity

            self.nextTextLabel.transform = .identity
            self.nextTextLabel.alpha = 0

            if self.paragraphIndex == self.animationText.count - 1 {
                self.nextTextLabel.text = ""
                self.nextTextLabel.alpha = 0
            } else {
                self.nextParagraphAnimation()
            }
        })
    }
}
