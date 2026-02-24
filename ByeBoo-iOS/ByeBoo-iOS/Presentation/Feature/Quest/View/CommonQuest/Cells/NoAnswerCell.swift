//
//  NoAnswerView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/19/26.
//

import UIKit

import SnapKit

final class NoAnswerCell: UITableViewCell {
    
    var topConstraint: Constraint?
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
        noAnswerLabel.applyByeBooFont(
            style: .body6R14,
            text: "아직 작성된 답변이 없어요!",
            color: .grayscale400,
            textAlignment: .center
        )
    }
    
    private func setUI() {
        addSubview(noAnswerLabel)
    }
    
    private func setLayout() {
        noAnswerLabel.snp.makeConstraints {
            topConstraint = $0.top.equalToSuperview().inset(70.adjustedH).constraint
            $0.horizontalEdges.equalToSuperview().inset(80.adjustedW)
            $0.bottom.equalToSuperview().inset(51.adjustedH)
        }
    }
}
