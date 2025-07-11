//
//  CongratSqusre.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import UIKit

import SnapKit
import Then

final class CongratSquare: BaseView {
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    
    override func setUI() {
        addSubviews(titleLabel, imageView, descriptionLabel)
    }
    
    override func setStyle() {
        self.do {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .white10
        }
        
        titleLabel.do {
            $0.attributedText = "QUEST\nCOMPLETE!".makeTitle(rangedText: "QUEST")
            $0.font = FontManager.head1Sb24.font
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
        
        imageView.do {
            $0.image = .congrate
            $0.contentMode = .scaleAspectFill
        }
        
        descriptionLabel.do {
            $0.font = FontManager.body3R16.font
            $0.text = "기특해요 !\n점점 극복에 가까워지고 있어요 :)"
            $0.textColor = .grayscale300
            $0.numberOfLines = 2
            $0.textAlignment = .center
        }
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(325.adjustedW)
            $0.height.equalTo(365.adjustedH)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(61.adjustedH)
            $0.width.equalTo(203.adjustedW)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.width.equalTo(203.adjustedW)
            $0.height.equalTo(181.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(61.adjustedH)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(61.adjustedH)
        }
    }
}
