//
//  SectionDividerView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

final class SectionDividerView: BaseView {
    
    let dividerView = UIView()
    
    override func setStyle() {
        dividerView.do {
            $0.backgroundColor = .white5
        }
    }
    
    override func setUI() {
        addSubview(dividerView)
    }
    
    override func setLayout() {
        dividerView.snp.makeConstraints {
            $0.height.equalTo(1.adjustedW)
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
    }

}
