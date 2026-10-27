//
//  CommonQuestReplyView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 5/8/26.
//

import UIKit

import SnapKit

final class CommonQuestReplyView: BaseView {
    private(set) var commentListView = UITableView()
    private(set) var commentTextView = CommentTextView()
    
    private var commentTextViewBottomConstraint: Constraint?
    
    override func setUI() {
        addSubviews(commentListView, commentTextView)
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        commentListView.do {
            $0.backgroundColor = .grayscale900
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    override func setLayout() {
        commentListView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(6.adjustedH)
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
