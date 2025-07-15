//
//  ThinkView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import SnapKit

final class ThinkView: BaseView {

    private let titleTextView = IconOneLineTextView(iconType: .think, text: "이렇게 생각했어요")
    private let descriptionView: TextBoxView
    
    var descriptionText: String
    
    init(descriptionText: String) {
        self.descriptionText = descriptionText
        descriptionView = TextBoxView(title: descriptionText)
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {

    }
    
    override func setUI() {
        addSubviews(
            titleTextView,
            descriptionView
        )
    }
    
    override func setLayout() {
        titleTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
        }
    }
}
