//
//  MyPageView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class MyPageView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let nameView = OneLineTextBoxView(title: "")
    private(set) var moveButton = UIButton()
    private let divider1 = SectionDividerView()
    private(set) var myRecordView = MyRecordView()
    private let worldView = ByeBooWorldView()
    private let divider2 = SectionDividerView()
    private(set) var inquireView = MyPageFeatureView(
        title: MyPageFeatureType.inquire.rawValue,
        features: MyPageFeatureType.inquire.features
    )
    private(set) var termAndPolicyView = MyPageFeatureView(
        title: MyPageFeatureType.termAndPolicy.rawValue,
        features: MyPageFeatureType.termAndPolicy.features
    )
    private(set) var accountView = MyPageFeatureView(
        title: MyPageFeatureType.account.rawValue,
        features: MyPageFeatureType.account.features
    )
    
    override func setStyle() {
        backgroundColor = .grayscale900
        moveButton.do {
            $0.setImage(.right.withTintColor(.grayscale50), for: .normal)
        }
    }
    
    override func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            nameView,
            divider1,
            myRecordView,
            worldView,
            divider2,
            inquireView,
            termAndPolicyView,
            accountView
        )
        nameView.addSubview(moveButton)
    }
    
    override func setLayout() {
        let safeArea = safeAreaLayoutGuide
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeArea)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        nameView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.top.equalToSuperview().offset(8.adjustedW)
        }
        moveButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20.adjustedW)
        }
        divider1.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        myRecordView.snp.makeConstraints {
            $0.top.equalTo(divider1.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        worldView.snp.makeConstraints {
            $0.top.equalTo(myRecordView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
        }
        divider2.snp.makeConstraints {
            $0.top.equalTo(worldView.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        inquireView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(24.5.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        termAndPolicyView.snp.makeConstraints {
            $0.top.equalTo(inquireView.snp.bottom).offset(24.5.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        accountView.snp.makeConstraints {
            $0.top.equalTo(termAndPolicyView.snp.bottom).offset(24.5.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
        }
    }
    
}

extension MyPageView {
    func updateName(_ name: String) {
        nameView.updateTitle("\(name)님")
    }
}

