//
//  ActionView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/9/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ActionView: BaseView {

    private let photoView = UIImageView()
    private let descriptionView: TextBoxView
    private let placeholderView = UIImageView()
    private let thinkTextView =  IconOneLineTextView(iconType: .think,text: "이렇게 완료했어요" )
    private let descriptionText: String
    private let photoURL: String
    
    init(
        descriptionText: String,
        photoURL: String
    ) {
        self.descriptionText = descriptionText
        self.photoURL = photoURL
        
        descriptionView = TextBoxView(title: descriptionText)
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        photoView.do {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.backgroundColor = .gray
            $0.contentMode = .scaleAspectFill
            guard let url = URL(string: photoURL) else {
                ByeBooLogger.error(ByeBooError.URLError)
                return
            }
            $0.kf.setImage(with: url)
        }
    }
    
    override func setUI() {
        addSubviews(
            photoView,
            thinkTextView
        )
        
        addSubview(descriptionView)
    }
    
    override func setLayout() {
        thinkTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.5.adjustedH)
            $0.leading.trailing.equalToSuperview().inset(24.adjustedW)
        }
        
        photoView.snp.makeConstraints {
            $0.top.equalTo(thinkTextView.snp.bottom).offset(12.adjustedH)
            $0.size.equalTo(327.adjustedW)
            $0.centerX.equalToSuperview()
            if descriptionText.isEmpty {
                $0.bottom.equalToSuperview().inset(24.5.adjustedH)
            }
        }
        
        descriptionView.snp.makeConstraints {
            $0.top.equalTo(photoView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(24.5.adjustedH)
        }
    }
}

extension ActionView {
    func updateUI(description: String, photoURL: String) {
        if description.isEmpty {
            descriptionView.removeFromSuperview()
            photoView.snp.remakeConstraints {
                $0.top.equalTo(thinkTextView.snp.bottom).offset(12.adjustedH)
                $0.size.equalTo(327.adjustedW)
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().inset(24.5.adjustedH)
            }
        } else {
            photoView.snp.remakeConstraints {
                $0.top.equalTo(thinkTextView.snp.bottom).offset(12.adjustedH)
                $0.size.equalTo(327.adjustedW)
                $0.centerX.equalToSuperview()
            }
        }
        self.descriptionView.updateText(description)
        
        if let url = URL(string: photoURL) {
            photoView.kf.setImage(with: url)
        }
    }
}
