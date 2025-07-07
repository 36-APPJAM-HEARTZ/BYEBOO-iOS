//
//  TextBoxView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

final class TextBoxView: BaseView {
    private let titleLabel = UILabel()
    private var tagView: ByeBooFilledTag? = nil
    
    private let title: String
    private let tagTitle: String?
    private let tagType: ByeBooFilledTagType?
    
    init(
        title: String,
        tagTitle: String? = nil,
        tagType: ByeBooFilledTagType? = nil
    ) {
        self.title = title
        self.tagTitle = tagTitle
        self.tagType = tagType
        
        self.titleLabel.text = title
        
        if let tagType,
           let tagTitle {
            tagView = ByeBooFilledTag(tagType: tagType, text: tagTitle)
        }

        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        layer.cornerRadius = 12
        backgroundColor = .white10
        
        titleLabel.do {
            $0.font = FontManager.body3R16.font
            $0.textColor = .grayscale300
        }
    }
    
    override func setUI() {
        if let tagView {
            addSubview(tagView)
        }
        
        addSubview(titleLabel)
    }
    
    override func setLayout() {
        if let tagView {
            tagView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(24.adjustedW)
                $0.centerY.equalToSuperview()
            }
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(tagView == nil ? 24.adjustedW : 91.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
}
