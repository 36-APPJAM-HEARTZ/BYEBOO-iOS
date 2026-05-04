//
//  NoticeContentView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 4/30/26.
//

import UIKit

final class NoticeContentView: BaseView {
    
    private let noticeStackView = UIStackView()
    private let emptyNoticeView = EmptyNoticeView()
    private(set) var noticeCardsView = NoticeCardsView()
    
    override func setStyle() {
        noticeStackView.do {
            $0.axis = .vertical
        }
    }
    
    override func setUI() {
        addSubview(noticeStackView)
        noticeStackView.addArrangedSubviews(
            emptyNoticeView,
            noticeCardsView
        )
    }
    
    override func setLayout() {
        noticeStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension NoticeContentView {
    
    func decideNoticeContent(isExistNotice: Bool) {
        noticeCardsView.isHidden = !isExistNotice
        emptyNoticeView.isHidden = isExistNotice
    }
}
