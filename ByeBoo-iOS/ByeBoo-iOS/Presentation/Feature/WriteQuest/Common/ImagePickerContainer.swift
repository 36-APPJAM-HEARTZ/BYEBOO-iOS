//
//  ImagePickerContainer.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 7/9/25.
//

import UIKit

import SnapKit
import Then

final class ImagePickerContainer: BaseView {
    let selectedImageView = UIImageView()
    private let addImageButton = UIView()
    private let plusIcon = UIImageView()
    
    var didTapAddImage: (() -> Void)?
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        addSubviews(selectedImageView, addImageButton)
        addImageButton.addSubview(plusIcon)
        
        setTapGesture()
    }
    
    override func setStyle() {
        self.do {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
        }
        
        selectedImageView.do {
            $0.isHidden = false
            $0.contentMode = .scaleAspectFill
        }
        
        addImageButton.do {
            $0.backgroundColor = .white5
        }
        
        plusIcon.do {
            $0.image = .plus.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .primary300
        }
    }
    
    override func setLayout() {
        selectedImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addImageButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        plusIcon.snp.makeConstraints {
            $0.width.height.equalTo(24.adjustedW)
            $0.center.equalToSuperview()
        }
    }
    
    func changeIconHidden() {
        plusIcon.isHidden = true
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imgButtonDidTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc
    private func imgButtonDidTap() {
        didTapAddImage?()
    }
}
