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
        case .completed:
            return .primary30020
        case .ongoing:
            return .primary300
        case .locked:
            return .white10
        }
    }
    
    var questNumberColor: UIColor {
        switch self {
        case .completed:
            return .primary300
        case .ongoing:
            return .primary50
        case .locked:
            return .white10
        }
    }
    
    var image: UIImage {
        switch self {
        case .completed:
            return .completed
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
    
    func setStyle() {
        questBackgroundView.do {
            $0.layer.cornerRadius = 12
        }
        frontView.do {
            $0.backgroundColor = .clear
        }
        questNumberLabel.do {
            $0.font = FontManager.cap1M12.font
        }
        imageView.do {
            $0.backgroundColor = .clear
            $0.contentMode = .scaleAspectFit
        }
    }
    
    func setUI() {
        questBackgroundView.addSubviews(frontView, questNumberLabel, imageView)
        addSubviews(questBackgroundView)
    }
    
    func setLayout() {
        questBackgroundView.snp.makeConstraints {
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
    }
    
    func dataBind(state: QuestState, questNumber: Int) {
        questBackgroundView.backgroundColor = state.backgroundColor
        questNumberLabel.text = String(format: "%02d", questNumber)
        questNumberLabel.textColor = state.questNumberColor
        imageView.image = state.image
        
        if state == .locked {
            imageView.tintColor = .white10
            imageView.snp.makeConstraints {
                $0.width.height.equalTo(24.adjustedW)
                $0.center.equalToSuperview()
            }
        } else {
            imageView.snp.makeConstraints {
                $0.top.equalTo(frontView.snp.top).offset(5.adjustedH)
                $0.centerX.equalTo(frontView.snp.centerX)
            }
        }
    }
}
