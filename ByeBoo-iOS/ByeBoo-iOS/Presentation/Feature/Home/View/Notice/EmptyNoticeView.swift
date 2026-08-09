//
//  EmptyNoticeView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 5/1/26.
//

import UIKit

final class EmptyNoticeView: BaseView {
    
    private let noNoticeLabel = UILabel()
    
    override func setStyle() {
        noNoticeLabel.applyByeBooFont(
            style: .body3R16,
            text: "아직 도착한 알림이 없어요!",
            color: .grayscale300
        )
    }
    
    override func setUI() {
        addSubview(noNoticeLabel)
    }
    
    override func setLayout() {
        noNoticeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(208.5.adjustedH)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(397.adjustedH)
        }
    }
}
