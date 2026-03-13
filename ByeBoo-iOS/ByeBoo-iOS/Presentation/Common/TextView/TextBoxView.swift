//
//  TextBoxView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

final class TextBoxView: BaseView {
    
    private let titleLabel = UILabel()
    private var emotionChip: ByeBooEmotionChip? = nil
    
    private let title: String
    private let emotionType: ByeBooEmotion?
    
    init(
        title: String,
        emotionType: ByeBooEmotion? = nil
    ) {
        self.title = title
        self.emotionType = emotionType
        
        self.titleLabel.text = title
        
        if let emotionType {
            emotionChip = ByeBooEmotionChip(emotionType: emotionType)
        }
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        layer.cornerRadius = 12
        backgroundColor = .white5
        
        titleLabel.applyByeBooFont(
            style: .body3R16,
            color: .grayscale100,
            numberOfLines: 0
        )
        titleLabel.lineBreakMode = .byCharWrapping
    }
    
    override func setUI() {
        if let emotionChip {
            addSubview(emotionChip)
        }
        
        addSubview(titleLabel)
    }
    
    override func setLayout() {
        if let emotionChip {
            emotionChip.snp.makeConstraints {
                $0.verticalEdges.equalToSuperview().inset(18.adjustedH)
                $0.leading.equalToSuperview().inset(24.adjustedW)
                $0.centerY.equalToSuperview()
            }
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18.adjustedH)
            $0.leading.equalToSuperview().inset(emotionChip == nil ? 24.adjustedW : 132.adjustedW)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
    }
}

extension TextBoxView {
    func updateText(_ text: String) {
        titleLabel.applyByeBooFont(
            style: .body3R16,
            text: text,
            color: .grayscale100,
            numberOfLines: 0
        )
    }
    
    func updateEmotionText(_ emotionState: String, text: String){
        titleLabel.applyByeBooFont(
            style: .body6R14,
            text: text,
            color: .grayscale100,
            numberOfLines: 0
        )
        self.emotionChip?.updateEmotion(ByeBooEmotion.toEmotion(text: emotionState))
    }
}
