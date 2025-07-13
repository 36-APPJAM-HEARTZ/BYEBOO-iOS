//
//  OnboardingTextView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

final class OnboardingTextView: BaseView {

    private let titleLabel = UILabel()
    
    var text: String
    
    init(text: String) {
        self.text = text
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .primary50
        layer.cornerRadius = 12
        
        titleLabel.do {
            $0.text = text
            $0.font = FontManager.body4Sb14.font
            $0.textColor = .primary400
        }
    }
    
    override func setUI() {
        addSubview(titleLabel)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(9.adjustedH)
        }
    }
}
