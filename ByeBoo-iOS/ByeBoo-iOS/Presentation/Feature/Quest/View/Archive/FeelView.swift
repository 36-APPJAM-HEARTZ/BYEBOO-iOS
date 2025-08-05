//
//  FeelView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import SnapKit

final class FeelView: BaseView {

    private let descriptionView: TextBoxView
    private var emotionType: String
    private var descriptionText: String
    
    private let titleTextView = IconOneLineTextView(iconType: .change, text: "퀘스트 완료 후, 이런 감정을 느꼈어요")
    
    init(emotionType: String, descriptionText: String) {
        self.emotionType = emotionType
        self.descriptionText = descriptionText
        
        descriptionView = TextBoxView(
            title: descriptionText,
            emotionType: ByeBooEmotion.toEmotion(text: emotionType)
        )
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(
            titleTextView,
            descriptionView
        )
    }
    
    override func setLayout() {
        titleTextView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
       
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
        }
    }
}

extension FeelView {
    func updateUI(emotionType: String, descriptionText: String) {
        self.descriptionView.updateEmotionText(emotionType, text: descriptionText)
    }
}
