//
//  OnboardingContentView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/10/25.
//

import UIKit

enum OnboardingStep: Int {
    case first = 1
    case second
    case third
}

final class OnboardingContentView: BaseView {
    
    private let firstView = UIView()
    private let firstTopImageView = UIImageView()
    private let firstTopDescriptionLabel = UILabel()
    private let firstBottomImageView = UIImageView()
    private let firstBottomDescriptionLable = UILabel()
    
    private let secondView = UIView()
    private let secondTopImageView = UIImageView()
    private let secondTopDescriptionLabel = UILabel()
    private let secondBottomImageView = UIImageView()
    private let secondBottomDescriptionLabel = UILabel()
    
    private let thirdView = UIView()
    private let thirdImageView = UIImageView()
    private let thirdDescriptionLabel = UILabel()
    
    var step: OnboardingStep = .first {
        didSet {
            changeStep()
        }
    }

    override func setStyle() {
        firstTopImageView.do {
            $0.image = .first
        }
        firstTopDescriptionLabel.do {
            $0.text = "저는 당신이 털어놓은 감정을 담는 보따리,\n보리라고 해요."
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale900
        }
        firstBottomImageView.do {
            $0.image = .second
        }
        firstBottomDescriptionLable.do {
            $0.text = "이별 후 걸림돌 같은 감정들을 털어놔주시면\n제 안에서 감정돌이 되어 쌓여요."
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale900
        }
        secondTopImageView.do {
            $0.image = .third
        }
        secondTopDescriptionLabel.do {
            $0.text = "당신이 준비가 되었을 때\n감정돌들을 하나씩 꺼내 바닥에 놓아드려요."
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale900
        }
        secondBottomImageView.do {
            $0.image = .fourth
        }
        secondBottomDescriptionLabel.do {
            $0.text = "제가 모아둔 감정돌을 디딤돌 삼아\n한 걸음 한 걸음 미래로 나아가주세요."
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale900
        }
        thirdImageView.do {
            $0.image = .fifth
        }
        thirdDescriptionLabel.do {
            $0.text = """
                자, 이제 시간이 됐어요.

                당신에게 꼭 맞는 이별 극복 여정에 따라
                퀘스트를 하나하나씩 진행하면서
                감정을 정리하고, 극복해 보아요.

                저 보리가 항상 함께할게요.
                """
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale900
        }
    }
    
    override func setUI() {
        switch step {
        case .first:
            addSubview(firstView)
            firstView.addSubviews(
                firstTopImageView,
                firstTopDescriptionLabel,
                firstBottomImageView,
                firstBottomDescriptionLable
            )
        case .second:
            addSubview(secondView)
            secondView.addSubviews(
                secondTopImageView,
                secondTopDescriptionLabel,
                secondBottomImageView,
                secondBottomDescriptionLabel
            )
        case .third:
            addSubview(thirdView)
            thirdView.addSubviews(
                thirdImageView,
                thirdDescriptionLabel
            )
        }
    }
    
    override func setLayout() {
        switch step {
        case .first:
            firstView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            firstTopImageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(19.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
                $0.height.equalTo(209.adjustedH)
            }
            firstTopDescriptionLabel.snp.makeConstraints {
                $0.top.equalTo(firstTopImageView.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
            }
            firstBottomImageView.snp.makeConstraints {
                $0.top.equalTo(firstTopDescriptionLabel.snp.bottom).offset(24.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
                $0.height.equalTo(209.adjustedH)
            }
            firstBottomDescriptionLable.snp.makeConstraints {
                $0.top.equalTo(firstBottomImageView.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
            }
        case .second:
            secondView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            secondTopImageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(19.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
                $0.height.equalTo(209.adjustedH)
            }
            secondTopDescriptionLabel.snp.makeConstraints {
                $0.top.equalTo(secondTopImageView.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
            }
            secondBottomImageView.snp.makeConstraints {
                $0.top.equalTo(secondTopDescriptionLabel.snp.bottom).offset(24.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
                $0.height.equalTo(209.adjustedH)
            }
            secondBottomDescriptionLabel.snp.makeConstraints {
                $0.top.equalTo(secondBottomImageView.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
            }
        case .third:
            thirdView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            thirdImageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(19.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
                $0.height.equalTo(372.adjustedH)
            }
            thirdDescriptionLabel.snp.makeConstraints {
                $0.top.equalTo(thirdImageView.snp.bottom).offset(24.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(48.adjustedW)
            }
        }
    }
}

extension OnboardingContentView {
    private func changeStep() {
        switch step {
        case .first:
            break
        case .second:
            firstView.removeFromSuperview()
            setUI()
            setLayout()
        case .third:
            secondView.removeFromSuperview()
            setUI()
            setLayout()
        }
    }
}
