//
//  BlockUserListView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/22/26.
//

import UIKit

final class BlockedUserCell: UITableViewCell {
    
    private let userNameLabel = UILabel()
    private(set) var clearButton = UIButton()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.do {
            $0.backgroundColor = .grayscale900
            $0.selectionStyle = .none
        }
        userNameLabel.applyByeBooFont(
            style: .body2M16,
            color: .grayscale100
        )
        clearButton.do {
            $0.setTitle("해제", for: .normal)
            $0.applyByeBooFont(style: .cap1M12, color: .grayscale100)
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.05)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.grayscale800.cgColor
            $0.layer.cornerRadius = 12
        }
    }
    
    private func setUI() {
        contentView.addSubviews(
            userNameLabel,
            clearButton
        )
    }
    
    private func setLayout() {
        userNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.verticalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        clearButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.adjustedW)
            $0.verticalEdges.equalToSuperview()
            $0.centerY.equalTo(userNameLabel.snp.centerY)
            $0.width.equalTo(56.adjustedW)
            $0.height.equalTo(24.adjustedH)
        }
    }
}

extension BlockedUserCell {
    
    func bind(userName: String) {
        userNameLabel.text = userName
    }
}
