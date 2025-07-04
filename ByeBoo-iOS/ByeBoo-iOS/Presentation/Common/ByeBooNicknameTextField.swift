//
//  NicknameTextField.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/4/25.
//

import SnapKit
import Then
import UIKit

final class ByeBooNicknameTextField: UIView {
    
    let nicknameField = UITextField()
    let errorIcon = UIImageView()
    
    init(_ type: NicknameFieldType) {
        super.init(frame: .zero)
        setUI()
        setStyle()
        setTextFieldStyle(type)
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        nicknameField.addSubview(errorIcon)
        addSubview(nicknameField)
    }
    
    private func setStyle() {
        nicknameField.do {
            $0.backgroundColor = .grayscale700
            $0.layer.cornerRadius = 12
            $0.attributedPlaceholder = NSAttributedString(
                string: "닉네임을 입력해주세요",
                attributes: [NSAttributedString.Key.foregroundColor : UIColor.grayscale300]
            )
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 0))
            $0.leftViewMode = .always
            $0.textColor = .grayscale300
        }
        
        errorIcon.do {
            $0.image = .errorRed
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 9
            $0.tintColor = .grayscale600
        }
    }
    
    private func setTextFieldStyle(_ type: NicknameFieldType) {
        nicknameField.do {
            $0.layer.borderWidth = type.borderWidth
            $0.layer.borderColor = type.borderColor
        }
        
        errorIcon.isHidden = type.isOccuredError
    }
    
    private func setLayout() {
        self.snp.makeConstraints {
            $0.width.equalTo(312)
            $0.height.equalTo(57)
        }
        
        nicknameField.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        errorIcon.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(18)
        }
    }
    
    private func setAction() {
        nicknameField.addTarget(self, action: #selector(nicknameFieldDidTap), for: .editingDidBegin)
        nicknameField.addTarget(self, action: #selector(nicknameFieldDidChange), for: .editingChanged)
    }
    
    @objc
    private func nicknameFieldDidTap() {
        setTextFieldStyle(.onBeginEditing)
    }
    
    @objc
    private func nicknameFieldDidChange() {
        guard let text = nicknameField.text else { return }
        
        if text.isEmpty {
            self.setTextFieldStyle(.onBeginEditing)
        } else if !text.isValidNickname {
            self.setTextFieldStyle(.error)
        } else {
            self.setTextFieldStyle(.normal)
        }
    }
}

extension ByeBooNicknameTextField {
    
    enum NicknameFieldType {
        case normal, onBeginEditing, error
        
        var borderWidth: CGFloat {
            switch self {
            case .onBeginEditing, .error:
                return 1
            default:
                return 0
            }
        }
        
        var borderColor: CGColor? {
            switch self {
            case .normal:
                return UIColor.clear.cgColor
            case .onBeginEditing:
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
}
