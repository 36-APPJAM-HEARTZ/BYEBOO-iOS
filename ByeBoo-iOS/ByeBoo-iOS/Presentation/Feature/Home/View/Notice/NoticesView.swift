//
//  NoticesView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 4/30/26.
//

import UIKit

import SnapKit

final class NoticesView: BaseView {
    
    private let noticesHeaderView = UIView()
    private let disappearDeadlineLabel = UILabel()
    private(set) var readAllButton = UIButton()
    private(set) var contentView = NoticeContentView()
    private var headerTopConstraint: Constraint?
    
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
    
    // iPhone Duo 대응: 네비바가 세로 바로 가서 위쪽 safe area가 0이면 화면 위에 붙지 않도록 여백을 더 줌
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        headerTopConstraint?.update(offset: safeAreaInsets.top > 0 ? 16.adjustedH : 24)
    }
    
    override func setLayout() {
        // iPhone Duo 대응: 오른쪽 세로 바와 겹치지 않도록 safe area 기준, 전체 폭은 가장 큰 iPhone(440)까지만 쓰고 가운데 정렬
        noticesHeaderView.snp.makeConstraints {
            headerTopConstraint = $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16.adjustedH).constraint
            $0.centerX.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(safeAreaLayoutGuide).offset(-48.adjustedW).priority(.high)
            $0.width.lessThanOrEqualTo(440 - 48.adjustedW)
            // 높이가 낮은 화면에서 글자가 잘리지 않도록 고정값
            $0.height.equalTo(16)
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
            $0.horizontalEdges.equalTo(noticesHeaderView)
            $0.bottom.equalToSuperview().inset(24.adjustedH)
        }
    }
}
