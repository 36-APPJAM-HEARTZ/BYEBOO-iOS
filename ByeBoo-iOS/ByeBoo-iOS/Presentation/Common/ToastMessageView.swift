//
//  ToastMessageView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 8/30/25.
//

import UIKit

final class ToastMessageView: BaseView {
    
    private let toastImageView = UIImageView()
    private let textLabel = UILabel()
    
    init(image: UIImage, text: String) {
        super.init(frame: .zero)
        self.toastImageView.image = image
        self.textLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        self.do {
            $0.backgroundColor = .black80
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 4
            $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
        
        textLabel.applyByeBooFont(style: .body6R14, color: .grayscale50)
    }
    
    override func setUI() {
        addSubviews(
            toastImageView,
            textLabel
        )
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(42.adjustedH)
        }
        toastImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
        textLabel.snp.makeConstraints {
            $0.leading.equalTo(toastImageView.snp.trailing).offset(8.adjustedW)
            $0.trailing.equalToSuperview().inset(16.adjustedW)
            $0.centerY.equalToSuperview()
        }
    }
}
