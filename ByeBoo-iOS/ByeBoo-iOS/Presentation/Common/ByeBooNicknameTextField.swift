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
            return nil
        case .normal:
            return UIColor.primary300.cgColor
        case .error:
            return UIColor.error300.cgColor
        }
    }
    
    var errorImage: UIImage? {
        switch self {
        case .onBeginEditing:
            return .error
        case .normal:
            return nil
        case .error:
            return .errorRed
        }
    }
}

final class ByeBooNicknameTextField: BaseView {
    
    private(set) var nicknameField = UITextField()
    let deleteAllTextButton = UIButton()
    
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
            $0.autocapitalizationType = .none
        }
        deleteAllTextButton.do {
            $0.backgroundColor = .white10
            $0.setImage(.union.withTintColor(.white).resize(newWidth: 10.adjustedW), for: .normal)
            $0.layer.cornerRadius = 9
            $0.isHidden = true
        }
    }
    
    private func setAction() {
        [UIControl.Event.editingDidBegin, UIControl.Event.editingChanged].forEach { event in
            nicknameField.addTarget(
                self,
                action: #selector(nicknameFieldDidChange),
                for: event
            )
        }
        deleteAllTextButton.addTarget(
            self,
            action: #selector(deleteAllTextButtonDidTap),
            for: .touchUpInside
        )
    }
    
    override func setUI() {
        addSubviews(
            nicknameField,
            deleteAllTextButton
        )
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
        
        deleteAllTextButton.snp.makeConstraints {
            $0.trailing.equalTo(nicknameField.snp.trailing).offset(-24.adjustedW)
            $0.centerY.equalTo(nicknameField.snp.centerY)
            $0.width.height.equalTo(18.adjustedW)
        }
    }
}

extension ByeBooNicknameTextField {
    
    func setTextFieldStyle(_ type: NicknameFieldType) {
        nicknameField.do {
            $0.layer.borderWidth = type.borderWidth
            $0.layer.borderColor = type.borderColor
        }
    }
    
    @objc
    private func nicknameFieldDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self,
                  let text = self.nicknameField.text else { return }
            
            let trimmedText = trimText(text)
            self.onTextChange?(trimmedText)
        }
    }
    
    @objc
    private func deleteAllTextButtonDidTap() {
        let blank = ""
        nicknameField.text = blank
        changeNicknameState(text: blank, isValid: true)
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
    
    func changeNicknameState(text: String, isValid: Bool) {
        let currentType: NicknameFieldType
        if text.isEmpty {
            currentType = .onBeginEditing
        } else if !isValid {
            currentType = .error
        } else {
            currentType = .normal
        }
        
        setTextFieldStyle(currentType)
        onRegex?(currentType == .normal)
        onStateChange?(currentType)
        updateDeleteAllTextButton(currentType)
    }
    
    private func updateDeleteAllTextButton(_ currentType: NicknameFieldType) {
        if currentType != .onBeginEditing {
            deleteAllTextButton.isHidden = false
            return
        }
        deleteAllTextButton.isHidden = true
    }
}
