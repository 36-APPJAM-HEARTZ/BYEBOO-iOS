//
//  NoticesView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 4/30/26.
//

import UIKit

final class NoticesView: BaseView {
    
    private let noticesHeaderView = UIView()
    private let disappearDeadlineLabel = UILabel()
    private(set) var readAllButton = UIButton()
    private(set) var contentView = NoticeContentView()
    
    override func setStyle() {
        disappearDeadlineLabel.applyByeBooFont(
            style: .cap1M12,
            text: "최근 30일까지의 알림만 보여요",
            color: .grayscale300
        )
        readAllButton.applyByeBooFont(
            style: .cap1M12,
            text: "모두 읽기",
            color: .grayscale300
        )
    }
    
    override func setUI() {
        addSubviews(
            noticesHeaderView,
            contentView
        )
        
        noticesHeaderView.addSubviews(
            disappearDeadlineLabel,
            readAllButton
        )
    }
    
    override func setLayout() {
        noticesHeaderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.height.equalTo(16.adjustedH)
        }
        disappearDeadlineLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        readAllButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        contentView.snp.makeConstraints {
            $0.top.equalTo(noticesHeaderView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
    }
}
