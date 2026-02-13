//
//  OneLineTextBoxView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

final class OneLineTextBoxView: BaseView {
    private let titleLabel = UILabel()
    private var tagView: ByeBooFilledTag? = nil
    
    private(set) var title: String
    private let tagTitle: String?
    private let tagType: ByeBooFilledTagType?
    private let isHighlighted: Bool
    
    init(
        title: String,
        tagTitle: String? = nil,
        tagType: ByeBooFilledTagType? = nil,
        isHighlighted: Bool = false
    ) {
        self.title = title
        self.tagTitle = tagTitle
        self.tagType = tagType
        self.isHighlighted = isHighlighted
        
        if let tagType,
           let tagTitle {
            tagView = ByeBooFilledTag(tagType: tagType, text: tagTitle)
        }
        
        super.init(frame: .zero)
        
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        layer.cornerRadius = 12
        backgroundColor = .white5
        
        if isHighlighted {
            layer.borderWidth = 1
            layer.borderColor = UIColor(.primary300).cgColor
        }
        
        titleLabel.applyByeBooFont(
            style: FontManager.body3R16,
            color: isHighlighted ? .grayscale50 : .grayscale300,
            numberOfLines: 1
        )
        titleLabel.isUserInteractionEnabled = false
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
            
            tagView.isUserInteractionEnabled = false
        }
        
        titleLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(18.adjustedH)
            if let tagView {
                $0.leading.equalTo(tagView.snp.trailing).offset(12.adjustedW)
            } else {
                $0.leading.equalToSuperview().inset(24.adjustedW)
            }
            $0.centerY.equalToSuperview()
        }
    }
}

extension OneLineTextBoxView {
    func updateTitle(_ text: String) {
        titleLabel.text = text
    }
}
