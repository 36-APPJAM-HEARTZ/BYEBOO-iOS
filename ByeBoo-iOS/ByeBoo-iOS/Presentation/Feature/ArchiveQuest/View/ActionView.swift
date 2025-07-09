//
//  ActionView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Kingfisher

final class ActionView: BaseView {

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let photoView = UIImageView()
    private let descriptionView: TextBoxView?
    private let placeholderView = UIImageView()
    
    private let descriptionText: String?
    private let photoURL: String
    
    init(
        descriptionText: String?,
        photoURL: String
    ) {
        self.descriptionText = descriptionText
        self.photoURL = photoURL
        
        if let text = descriptionText {
            descriptionView = TextBoxView(title: text)
        } else {
            descriptionView = nil
        }
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        iconImageView.do {
            $0.image = .think
        }
        titleLabel.do {
            $0.text = "이렇게 완료했어요"
            $0.font = FontManager.body2M16.font
            $0.textColor = .grayscale200
        }
        photoView.do {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.backgroundColor = .gray
            guard let url = URL(string: photoURL) else {
                ByeBooLogger.error(ByeBooError.URLError)
                return
            }
            $0.kf.setImage(with: url)
        }
    }
    
    override func setUI() {
        addSubviews(
            iconImageView,
            titleLabel,
            photoView
        )
        
        if let descriptionView {
            addSubview(descriptionView)
        }
    }
    
    override func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.adjustedW)
        }
        photoView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.adjustedH)
            $0.size.equalTo(327.adjustedW)
            $0.centerX.equalToSuperview()
        }
        if let descriptionView {
            descriptionView.snp.makeConstraints {
                $0.top.equalTo(photoView.snp.bottom).offset(12.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
                $0.bottom.equalToSuperview().inset(24.5.adjustedH)
            }
        }
    }
}
