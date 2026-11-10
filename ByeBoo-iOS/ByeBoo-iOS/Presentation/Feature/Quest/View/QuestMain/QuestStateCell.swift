//
//  QuestCompletedView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import UIKit

import SnapKit
import Then

final class QuestStateCell: UICollectionViewCell {
    
    private let questBackgroundView = UIView()
    private let frontView = UIView()
    private let questNumberLabel = UILabel()
    private let imageContentView = UIView()
    private let imageView = UIImageView()
    private let timerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        questBackgroundView.layer.cornerRadius = 12
        frontView.backgroundColor = .clear
        questNumberLabel.applyByeBooFont(style: .cap1M12, color: .white50)
        imageContentView.backgroundColor = .clear
        imageView.backgroundColor = .clear
        timerLabel.applyByeBooFont (
            style: .cap1M12,
            color: .secondary300,
            textAlignment: .center
        )
    }
    
    private func setUI() {
        imageContentView.addSubview(imageView)
        questBackgroundView.addSubviews(
            frontView,
            questNumberLabel,
            imageContentView,
            timerLabel
        )
        addSubviews(questBackgroundView)
    }
    
    private func setLayout() {
        // iPhone Duo 대응: 칸 크기는 레이아웃(CollectionViewFactory)이 정하고, 안쪽은 디자인 비율(96 : 80 : 24)대로
        questBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        frontView.snp.makeConstraints {
            $0.size.equalTo(questBackgroundView).multipliedBy(80.0 / 96.0)
            $0.center.equalToSuperview()
        }
        questNumberLabel.snp.makeConstraints {
            $0.top.equalTo(frontView.snp.top)
            $0.leading.equalTo(frontView.snp.leading)
        }
        imageContentView.snp.makeConstraints {
            $0.size.equalTo(questBackgroundView).multipliedBy(80.0 / 96.0)
            $0.center.equalToSuperview()
        }
        timerLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12.adjustedH)
            $0.centerX.equalToSuperview()
        }
    }
}

extension QuestStateCell {
    
    func bind(state: QuestState, questNumber: Int) {
        bindUI(state: state, questNumber: questNumber)
        bindLayout(state: state)
    }
    
    func updateRemainingTime(_ remainingTime: String) {
        timerLabel.text = remainingTime
    }
    
    private func bindUI(state: QuestState, questNumber: Int) {
        questBackgroundView.do {
            $0.backgroundColor = state.backgroundColor
            $0.layer.borderColor = state.strokeColor
            $0.layer.borderWidth = state.strokeWidth
        }
        questNumberLabel.do {
            $0.text = String(format: "%02d", questNumber)
            $0.textColor = state.questNumberColor
        }
        imageView.do {
            $0.image = state.image
            $0.tintColor = state.tintColor
            $0.contentMode = .scaleAspectFit
        }
        timerLabel.do {
            $0.isHidden = state.isHiddenTimer
            $0.text = state.timerText
        }
    }
    
    private func bindLayout(state: QuestState) {
        imageView.snp.remakeConstraints {
            switch state {
            case .upComing, .locked:
                $0.center.equalToSuperview()
                $0.size.equalToSuperview().multipliedBy(24.0 / 80.0)
            case .completed:
                $0.centerX.equalToSuperview()
                $0.size.equalToSuperview()
                $0.edges.equalToSuperview().inset(
                    UIEdgeInsets(
                        top: 8.adjustedH,
                        left: 3.adjustedW,
                        bottom: 0.adjustedH,
                        right: 3.adjustedW
                    )
                )
            case .ongoing:
                $0.centerX.equalToSuperview()
                $0.size.equalToSuperview()
            }
        }
    }
}
