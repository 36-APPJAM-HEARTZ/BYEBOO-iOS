//
//  CongratSqusre.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/10/25.
//

import UIKit

import Lottie
import SnapKit
import Then

final class CongratSquare: BaseView {
    private let titleLabel = UILabel()
    private let imageLottie = LottieAnimationView(name: "bori_congrate")
    private let descriptionLabel = UILabel()
    
    override func setUI() {
        addSubviews(titleLabel, imageLottie, descriptionLabel)
    }
    
    override func setStyle() {
        self.do {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = .white5
        }
        
        titleLabel.do {
            $0.attributedText = "QUEST\nCOMPLETE!".makeTitle(
                rangedText: "QUEST",
                originalTitleColor: .primary100
            )
            $0.applyByeBooFont(
                style: .head1M24,
                color: .primary100,
                textAlignment: .center,
                numberOfLines: 2
            )
        }
        
        imageLottie.do {
            $0.play()
            $0.loopMode = .playOnce
            $0.contentMode = .scaleAspectFill
        }
        
        descriptionLabel.applyByeBooFont (
            style: .body3R16,
            text: "기특해요!\n점점 극복해 나가고 있어요 :)",
            color: .grayscale300,
            textAlignment: .center,
            numberOfLines: 2
        )
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
        
        imageLottie.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.adjustedH)
            $0.width.equalTo(203.adjustedW)
            $0.height.equalTo(181.adjustedH)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(imageLottie.snp.bottom).offset(16.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(61.adjustedH)
        }
    }
}
