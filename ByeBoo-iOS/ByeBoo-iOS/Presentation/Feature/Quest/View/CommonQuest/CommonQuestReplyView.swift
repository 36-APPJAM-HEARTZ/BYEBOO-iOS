//
//  CommonQuestReplyView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/8/26.
//

import UIKit

import SnapKit

final class CommonQuestReplyView: BaseView {
    private let headerView = UIView()
    private(set) var backButton = UIButton()
    private let headerLabel = UILabel()
    private(set) var commentListView = UITableView()
    private(set) var commentTextView = CommentTextView()
    
    private var commentTextViewBottomConstraint: Constraint?
    
    override func setUI() {
        addSubviews(headerView, commentListView, commentTextView)
        headerView.addSubviews(backButton, headerLabel)
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        backButton.do {
            $0.setImage(.left.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.tintColor = .white
        }
        
        headerLabel.do {
            $0.applyByeBooFont(style: .sub1Sb20, text: "답글", color: .white)
        }
        
        commentListView.do {
            $0.backgroundColor = .grayscale900
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    override func setLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40.adjustedH)
        }
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedH)
            $0.size.equalTo(24.adjustedH)
        }
        headerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.adjustedH)
            $0.centerX.equalToSuperview()
        }
        commentListView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(6.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(20.adjustedW)
            $0.bottom.equalTo(commentTextView.snp.top)
        }
        commentTextView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            commentTextViewBottomConstraint = $0.bottom.equalToSuperview().inset(34.adjustedH).constraint
        }
    }
}

extension CommonQuestReplyView {
    func updateLayout(keyboardHeight: CGFloat) {
        let inset = keyboardHeight > 0 ? keyboardHeight : 34.adjustedH
        commentTextViewBottomConstraint?.update(inset: inset)
    }
}
