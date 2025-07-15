//
//  QuestCompletedView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/10/25.
//

import UIKit

import SnapKit
import Then

enum QuestState {
    
    case completed, ongoing, locked
    
    var backgroundColor: UIColor {
        switch self {
        case .completed, .locked:
            return .white10
        case .ongoing:
            return .primary30020
        }
    }
    
    var questNumberColor: UIColor {
        switch self {
        case .completed:
            return .white50
        case .ongoing:
            return .primary300
        case .locked:
            return .white10
        }
    }
    
    var strokeColor: CGColor {
        switch self {
        case .ongoing:
            return UIColor.primary300.cgColor
        case .completed, .locked:
            return UIColor.clear.cgColor
        }
    }
    
    var strokeWidth: CGFloat {
        switch self {
        case .ongoing:
            return 1
        case .completed, .locked:
            return 0
        }
    }
    
    var image: UIImage {
        switch self {
        case .completed:
            return .boriStamp
        case .ongoing:
            return .travel
        case .locked:
            return .lock.withRenderingMode(.alwaysTemplate)
        }
    }
}

final class QuestStateCell: UICollectionViewCell {
    
    private let questBackgroundView = UIView()
    private let frontView = UIView()
    private let questNumberLabel = UILabel()
    private let imageContentView = UIView()
    private let imageView = UIImageView()
    
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
        questNumberLabel.font = FontManager.cap1M12.font
        imageContentView.backgroundColor = .clear
        imageView.backgroundColor = .clear
    }
    
    private func setUI() {
        imageContentView.addSubview(imageView)
        questBackgroundView.addSubviews(
            frontView,
            questNumberLabel,
            imageContentView
        )
        addSubviews(questBackgroundView)
    }
    
    private func setLayout() {
        questBackgroundView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(96.adjustedW)
        }
        frontView.snp.makeConstraints {
            $0.width.height.equalTo(80.adjustedW)
            $0.center.equalToSuperview()
        }
        questNumberLabel.snp.makeConstraints {
            $0.top.equalTo(frontView.snp.top)
            $0.leading.equalTo(frontView.snp.leading)
        }
        imageContentView.snp.makeConstraints {
            $0.width.height.equalTo(80.adjustedW)
            $0.center.equalToSuperview()
        }
    }
}

extension QuestStateCell {
    
    func bind(state: QuestState, questNumber: Int) {
        bindUI(state: state, questNumber: questNumber)
        bindLayout(state: state)
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
            $0.tintColor = state == .locked ? .white10 : .clear
            $0.contentMode = .scaleAspectFit
        }
    }
    
    private func bindLayout(state: QuestState) {
        imageView.snp.remakeConstraints {
            if state == .locked {
                $0.center.equalToSuperview()
                $0.width.height.equalTo(24.adjustedW)
            } else {
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(80.adjustedW)
                $0.edges.equalToSuperview().inset(
                    UIEdgeInsets(
                        top: 8.adjustedH,
                        left: 3.adjustedW,
                        bottom: 0.adjustedH,
                        right: 3.adjustedW
                    )
                )
            }
        }
    }
}
