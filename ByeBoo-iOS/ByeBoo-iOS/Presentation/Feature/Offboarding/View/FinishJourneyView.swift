//
//  FinishJourneyView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

import Lottie

final class FinishJourneyView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let firstTextLabel = UILabel()
    private let secondTextLabel = UILabel()
    private let thirdTextLabel = UILabel()
    private let characterLottie = LottieAnimationView(name: "bori_cake")
    
    let startButton = ByeBooButton(titleText: "새로운 이별 극복 여정 시작하기", type: .enabled)
    let lookBackButton = ByeBooButton(titleText: "완료한 여정 다시보기", type: .sub)
    let backHomeLabel = UILabel()
    
    private let animationText: [String] = [
        "무려 30개의 퀘스트를 완료했어요.\n끝까지 포기하지 않고 극복하기 위해 노력한\n하츠핑님이 너무 대단해요.",
        "지금의 하츠핑님은, 처음보다 성장했을 거예요.",
        "만약 아직 정리되지 못한 감정이 남아있다면,\n또 다른 새로운 여정을 시작해볼까요?"
    ]
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
        characterLottie.do {
            $0.play()
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFill
        }
        startButton.do {
            $0.setImage(UIImage(named: "reset")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
            $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4.adjustedW)
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4.adjustedW, bottom: 0, right: 0)
        }
        firstTextLabel.do {
            $0.text = animationText[0]
            $0.numberOfLines = 0
            $0.font = FontManager.body6R14.font
            $0.textColor = .secondary50
            $0.textAlignment = .center
        }
        
        secondTextLabel.do {
            $0.text = animationText[1]
            $0.numberOfLines = 0
            $0.font = FontManager.cap2R12.font
            $0.textColor = .secondary5050
            $0.textAlignment = .center
        }
        
        thirdTextLabel.do {
            $0.text = animationText[2]
            $0.numberOfLines = 0
            $0.font = FontManager.cap2R12.font
            $0.textColor = .secondary5050
            $0.textAlignment = .center
            $0.alpha = 0
        }
    }
    
    override func setUI() {
        addSubviews(
            backgroundImageView,
            backgroundView,
            titleLabel,
            firstTextLabel,
            secondTextLabel,
            thirdTextLabel,
            characterLottie,
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
        firstTextLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24.adjustedH)
            $0.centerX.equalToSuperview()
        }
        secondTextLabel.snp.makeConstraints {
            $0.top.equalTo(firstTextLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        thirdTextLabel.snp.makeConstraints {
            $0.top.equalTo(secondTextLabel.snp.bottom).offset(16.adjustedH)
            $0.centerX.equalToSuperview()
        }
        characterLottie.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(154.adjustedH)
            $0.width.height.equalTo(290.adjustedH)
            $0.centerX.equalToSuperview()
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(characterLottie.snp.bottom).offset(30.adjustedH)
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
        UIView.transition(with: self.secondTextLabel, duration: 2.1, options: .transitionCrossDissolve, animations: {
            self.secondTextLabel.textColor = .secondary50
        }, completion: { _ in
            UIView.transition(with: self.thirdTextLabel, duration: 2, options: .transitionCrossDissolve) {
                self.thirdTextLabel.textColor = .secondary50
            }
        })
        
        UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseInOut], animations: {
            self.firstTextLabel.transform = CGAffineTransform(translationX: 0, y: -20)
            self.firstTextLabel.alpha = 0
            
            let animation = CGAffineTransform(translationX: 0, y: -50)
            self.secondTextLabel.transform = animation.scaledBy(x: 1.2, y: 1.2)
            
            self.thirdTextLabel.alpha = 1
            self.thirdTextLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            
        }) { _ in
            UIView.animate(withDuration: 1, delay: 1, options: [.curveEaseInOut], animations: {
                self.secondTextLabel.transform = CGAffineTransform(translationX: 0, y: -70)
                self.secondTextLabel.alpha = 0
                
                let animation = CGAffineTransform(translationX: 0, y: -100)
                self.thirdTextLabel.transform = animation.scaledBy(x: 1.2, y: 1.2)
            })
        }
    }
}
