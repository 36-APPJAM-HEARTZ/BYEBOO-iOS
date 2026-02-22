//
//  NoAnswerView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/19/26.
//

import UIKit

final class NoAnswerCell: UITableViewCell {
    
    private let noAnswerLabel = UILabel()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale900
            $0.selectionStyle = .none
        }
        noAnswerLabel.do {
            $0.text = "아직 작성된 답변이 없어요!"
            $0.textColor = .grayscale400
            $0.textAlignment = .center
            $0.font = FontManager.body6R14.font
        }
    }
    
    private func setUI() {
        addSubview(noAnswerLabel)
    }
    
    private func setLayout() {
        noAnswerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(70.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(80.adjustedW)
            $0.bottom.equalToSuperview().inset(51.adjustedH)
        }
    }
}
