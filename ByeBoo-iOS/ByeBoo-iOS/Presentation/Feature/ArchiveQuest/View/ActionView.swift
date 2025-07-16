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
    private let descriptionView: TextBoxView?
    private let placeholderView = UIImageView()
    private let thinkTextView =  IconOneLineTextView(iconType: .think,text: "이렇게 완료했어요" )
    var descriptionText: String?
    var photoURL: String
    
    init(
        descriptionText: String,
        photoURL: String
    ) {
        self.descriptionText = descriptionText
        self.photoURL = photoURL
        
        if descriptionText != ""  {
            descriptionView = TextBoxView(title: descriptionText)
        } else {
            descriptionView = nil
        }
        
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
            $0.contentMode = .scaleAspectFit
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
        
        if let descriptionView {
            addSubview(descriptionView)
        }
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
            if descriptionView == nil {
                $0.bottom.equalToSuperview().inset(24.5.adjustedH)
            }
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

extension ActionView {
    func updateUI(description: String, photoURL: String) {
        self.descriptionText = description
        self.photoURL = photoURL
        if let url = URL(string: photoURL) {
            photoView.kf.setImage(with: url)
        }
    }
}
