//
//  SpeechTextBoxView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 8/16/25.
//

import UIKit

final class SpeechTextBoxView: BaseView {
    
    private let image = UIImageView()
    private let titleLabel = UILabel()
    
    init(
        title: String
    ) {
        self.titleLabel.text = title
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        image.do {
            $0.image = .speechBubble
            $0.contentMode = .scaleAspectFit
            $0.clipsToBounds = false
        }
        
        titleLabel.applyByeBooFont(style: .body2M16, color: .primary50)
    }
    
    override func setUI() {
        addSubviews(
            image,
            titleLabel
        )
    }
    
    override func setLayout() {
        image.snp.makeConstraints {
            $0.width.equalTo(327.adjustedW)
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(image.snp.top).offset(14.adjustedH)
            $0.centerX.equalTo(image)
        }
    }
}

extension SpeechTextBoxView {
    func updateText(_ text: String, withAnimation: Bool = false) {
        if withAnimation {
            UIView.transition(with: titleLabel, duration: 1, options: .transitionCrossDissolve) { [weak self] in
                self?.titleLabel.text = text
            }
        } else {
            titleLabel.text = text
        }
    }
}
