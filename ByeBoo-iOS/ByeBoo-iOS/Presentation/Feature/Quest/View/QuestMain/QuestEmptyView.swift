//
//  QuestEmptyView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 5/5/26.
//

import UIKit

final class QuestEmptyView: BaseView {
    
    private let stackView = UIStackView()
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    let button = ByeBooButton(titleText: "보리 만나러 가기", type: .enabled)

    override func setStyle() {
        stackView.do {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .center
        }
        
        imageView.do {
            $0.image = .talk
        }
        
        textLabel.do {
            $0.text = "하츠핑님, 수고하셨어요.\n보리가 하고 싶은 말이 있다고 해요!"
            $0.applyByeBooFont(style: .sub3M18, color: .grayscale50)
            $0.numberOfLines = 2
        }
    }
    
    override func setUI() {
        addSubview(stackView)
        stackView.addArrangedSubviews(imageView, textLabel, button)
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension QuestEmptyView {
    func configure(name: String) {
        textLabel.text = "\(name)님, 수고하셨어요.\n보리가 하고 싶은 말이 있다고 해요!"
    }
}
