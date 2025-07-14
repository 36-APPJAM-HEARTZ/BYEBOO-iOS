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

    private let nameView = OneLineTextBoxView(title: "")
    private let divider1 = SectionDividerView()
    let myRecordView = MyRecordView()
    
    override func setStyle() {
        backgroundColor = .grayscale900
    }
    
    override func setUI() {
        addSubviews(
            nameView,
            divider1,
            myRecordView
        )
    }
    
    override func setLayout() {
        let safeArea = safeAreaLayoutGuide
        nameView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.top.equalTo(safeArea).offset(8.adjustedW)
        }
        divider1.snp.makeConstraints {
            $0.top.equalTo(nameView.snp.bottom).offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        myRecordView.snp.makeConstraints {
            $0.top.equalTo(divider1.snp.bottom).offset(8.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
}

extension MyPageView {
    func updateName(_ name: String) {
        nameView.updateTitle("\(name)님")
    }
}

