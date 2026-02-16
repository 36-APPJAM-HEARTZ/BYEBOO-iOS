//
//  TopTabBarItemView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/12/26.
//

import UIKit

final class TopTabBarItemView: BaseView {
    
    private let tabStackView = UIStackView()
    private let tabImageView = UIImageView()
    private let tabNameLabel = UILabel()
    private let underlineLabel = UILabel()
    
    init(item: any TabItem) {
        tabImageView.image = item.image
        tabNameLabel.text = item.title
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        tabStackView.do {
            $0.axis = .horizontal
            $0.spacing = 2
            $0.alignment = .center
        }
        tabNameLabel.do {
            $0.textColor = .grayscale100
            $0.font = FontManager.body2M16.font
            $0.textAlignment = .center
        }
        underlineLabel.do {
            $0.layer.borderColor = UIColor.grayscale300.cgColor
            $0.layer.borderWidth = 1
        }
    }
    
    override func setUI() {
        addSubviews(
            tabStackView,
            underlineLabel
        )
        tabStackView.addArrangedSubviews(
            tabImageView,
            tabNameLabel
        )
    }
    
    override func setLayout() {
        tabStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(108.adjustedW)
            $0.height.equalTo(24.adjustedH)
        }
        tabImageView.snp.makeConstraints {
            $0.size.equalTo(24.adjustedW)
            $0.verticalEdges.equalToSuperview()
            $0.leading.equalToSuperview().inset(9.5.adjustedW)
        }
        tabNameLabel.snp.makeConstraints {
            $0.leading.equalTo(tabImageView.snp.trailing).offset(2.adjustedW)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(11.5.adjustedW)
        }
        underlineLabel.snp.makeConstraints {
            $0.top.equalTo(tabStackView.snp.bottom).offset(4.adjustedH)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1.adjustedH)
            $0.bottom.equalToSuperview()
        }
    }
}

extension TopTabBarItemView {
    
    func updateBarItem(for tag: Int) {
        let condition = (self.tag == tag)
        
        tabImageView.layer.opacity = condition ? 1 : 0.44
        tabNameLabel.textColor = condition ?  .grayscale100 : .grayscale600
        underlineLabel.layer.borderColor = condition ? UIColor.grayscale300.cgColor : UIColor.clear.cgColor
        underlineLabel.layer.borderWidth = condition ? 1 : 0
    }
}
