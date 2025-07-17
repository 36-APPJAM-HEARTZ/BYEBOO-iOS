//
//  NicknameTextField.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/4/25.
//

import UIKit

import SnapKit
import Then

enum NicknameFieldType {
    case normal, onBeginEditing, error
    
    var borderWidth: CGFloat {
        switch self {
        case .normal, .error:
            return 1
        default:
            return 0
        }
    }
    
    var borderColor: CGColor? {
        switch self {
        case .onBeginEditing:
            return UIColor.clear.cgColor
        case .normal:
            return UIColor.primary300.cgColor
        case .error:
            return UIColor.error300.cgColor
        }
    }
    
    var isOccuredError: Bool {
        switch self {
        case .error:
            return false
        default:
            return true
        }
    }
}

final class ByeBooNicknameTextField: BaseView {
    
    let nicknameField = UITextField()
    let errorIcon = UIImageView()
    
    var onTextChange: ((String) -> Void)?
    var onRegex: ((Bool) -> Void)?
    var onStateChange: ((NicknameFieldType) -> Void)?
    
    init(_ type: NicknameFieldType) {
        super.init(frame: .zero)
        setTextFieldStyle(type)
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        nicknameField.do {
            $0.backgroundColor = .white10
            $0.layer.cornerRadius = 12.adjustedW
            $0.attributedPlaceholder = NSAttributedString(
                string: "닉네임을 입력해주세요",
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayscale300]
            )
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24.adjustedW, height: 0))
            $0.leftViewMode = .always
            $0.textColor = .grayscale300
            $0.tintColor = .white
        }
        
        errorIcon.do {
            $0.image = .errorRed
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 9.adjustedW
            $0.tintColor = .grayscale600
        }
    }
    
    override func setUI() {
        nicknameField.addSubview(errorIcon)
        addSubview(nicknameField)
    }
    
    override func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(327.adjustedW)
            $0.height.equalTo(56.adjustedH)
        }
        
        nicknameField.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        errorIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24.adjustedW)
        }
    }
    
    func setTextFieldStyle(_ type: NicknameFieldType) {
        nicknameField.do {
            $0.layer.borderWidth = type.borderWidth
            $0.layer.borderColor = type.borderColor
        }
        
        errorIcon.isHidden = type.isOccuredError
    }
    
    private func setAction() {
        nicknameField.addTarget(self, action: #selector(nicknameFieldDidTap), for: .editingDidBegin)
        nicknameField.addTarget(self, action: #selector(nicknameFieldDidChange), for: .editingChanged)
    }
    
    @objc
    private func nicknameFieldDidTap() {
        if let text = nicknameField.text {
            changeNicknameState(text: text)
        }
    }
    
    @objc
    private func nicknameFieldDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let text = self.nicknameField.text else { return }
            
            let trimmedText = trimText(text)
            self.onTextChange?(trimmedText)
            
            changeNicknameState(text: trimmedText)
        }
    }
    
    private func trimText(_ text: String?) -> String {
        if let text {
            let trimmedText = text.trim(limit: 5)
            
            if text != trimmedText {
                self.nicknameField.text = trimmedText
            }
            return trimmedText
        }
        return ""
    }
    
    private func changeNicknameState(text: String) {
        let currentType: NicknameFieldType
        if text.isEmpty {
            currentType = .onBeginEditing
        } else if !text.isValidNickname {
            currentType = .error
        } else {
            currentType = .normal
        }
        
        self.setTextFieldStyle(currentType)
        self.onRegex?(currentType == .normal)
        self.onStateChange?(currentType)
    }
}
