//
//  MyPageFeaturesView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/25/26.
//

import UIKit

final class MyPageFeaturesView: BaseView {
    
    private(set) var inquireView = MyPageFeatureView(type: .inquire)
    private(set) var noticeView = MyPageFeatureView(type: .notice)
    private(set) var participantView = MyPageFeatureView(type: .participant)
    private(set) var manageView = MyPageFeatureView(type: .manage)
    private(set) var termAndPolicyView = MyPageFeatureView(type: .termAndPolicy)
    private(set) var accountView = MyPageFeatureView(type: .account)
    
    override func setUI() {
        addSubviews(
            inquireView,
            noticeView,
            participantView,
            manageView,
            termAndPolicyView,
            accountView
        )
    }
    
    override func setLayout() {
        inquireView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        noticeView.snp.makeConstraints {
            $0.top.equalTo(inquireView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        participantView.snp.makeConstraints {
            $0.top.equalTo(noticeView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        manageView.snp.makeConstraints {
            $0.top.equalTo(participantView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        termAndPolicyView.snp.makeConstraints {
            $0.top.equalTo(manageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        accountView.snp.makeConstraints {
            $0.top.equalTo(termAndPolicyView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
