//
//  MyRecordView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

final class MyRecordView: BaseView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    // TODO: 제스처 연결하기
    let textBoxView = TextBoxView(title: "완료한 여정 돌아보기", isHighlighted: true)
    
    override func setStyle() {
        iconImageView.do {
            $0.image = .write
        }
        
        titleLabel.do {
            $0.text = "나의 기록"
            $0.font = FontManager.body1Sb16.font
            $0.textColor = .grayscale300
        }
    }
    
    override func setUI() {
        addSubviews(
            iconImageView,
            titleLabel,
            textBoxView
        )
    }
    
    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.adjustedW)
            $0.top.equalToSuperview().inset(24.5.adjustedH)
        }
        
        textBoxView.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(12.adjustedH)
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
    }

}
