//
//  IconOneLineTextView.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import UIKit

import SnapKit
import Then

enum IconType {
    case think
    case write
    case change
    case action
    
    var iconImage: UIImageView {
        switch self {
        case .think:
            return UIImageView(image: .think)
        case .write:
            return UIImageView(image: .write)
        case .change:
            return UIImageView(image: .change)
        case .action:
            return UIImageView(image: .shoeIcon)
        }
    }
}

final class IconOneLineTextView: BaseView {
    private let icon = UIImageView()
    private let textLabel = UILabel()
    
    init(iconType: IconType, text: String) {
        super.init(frame: .zero)
        icon.image = iconType.iconImage.image
        textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(icon, textLabel)
    }
    
    override func setStyle() {
        icon.do {
            $0.contentMode = .scaleAspectFit
        }
        
        textLabel.applyByeBooFont(style: FontManager.body2M16, color: .grayscale200)
    }
    
    override func setLayout() {
        icon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.height.equalTo(24.adjustedW)
            $0.leading.equalToSuperview()
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(icon.snp.trailing).offset(8.adjustedW)
            $0.centerY.equalTo(icon.snp.centerY)
        }
    }
}
