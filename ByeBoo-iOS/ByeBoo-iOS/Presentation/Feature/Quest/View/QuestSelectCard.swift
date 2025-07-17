//
//  QuestSelectCard.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

enum QuestCardType {
    case start
    case lookBack
    
    var title: String {
        switch self {
        case .start:
            "새로운 이별 극복 여정\n시작하기"
        case .lookBack:
            "내가 완료한 여정\n돌아보기"
        }
    }
    
    var character: UIImage {
        switch self {
        case .start:
                .newJourney
        case .lookBack:
                .completeJourney
        }
    }
}

final class QuestSelectCard: BaseView {

    private let titleLabel = UILabel()
    private let characterImageView = UIImageView()
    
    private let type: QuestCardType
    
    init(type: QuestCardType) {
        self.type = type
        
        super.init(frame: .zero)
        
        titleLabel.text = type.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .white10
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor(.grayscale700).cgColor
        
        titleLabel.do {
            $0.text = type.title
            $0.numberOfLines = 2
            $0.font = FontManager.head1M24.font
            $0.textColor = .grayscale50
        }
        characterImageView.do {
            $0.image = type.character
            $0.contentMode = .scaleAspectFit
        }
    }
    
    override func setUI() {
        addSubviews(characterImageView, titleLabel)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(240.adjustedH)
            $0.width.equalTo(327.adjustedW)
        }
        characterImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
        }
    }
    
}
