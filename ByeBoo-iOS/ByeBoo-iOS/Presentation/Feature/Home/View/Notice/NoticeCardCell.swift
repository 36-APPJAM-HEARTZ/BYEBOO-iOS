//
//  NoticeCardCell.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 5/1/26.
//

import UIKit

final class NoticeCardCell: UITableViewCell {
    
    private let noticeImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let writtenTimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
            $0.layer.cornerRadius = 12
        }
        titleLabel.applyByeBooFont(
            style: .body1Sb16,
            color: .grayscale200,
            textAlignment: .left
        )
        subtitleLabel.applyByeBooFont(
            style: .body6R14,
            color: .grayscale100,
            textAlignment: .left
        )
        writtenTimeLabel.applyByeBooFont(
            style: .cap2R12,
            color: .grayscale400,
            textAlignment: .left
        )
    }
    
    private func setUI() {
        addSubviews(
            noticeImageView,
            titleLabel,
            subtitleLabel,
            writtenTimeLabel
        )
    }
    
    private func setLayout() {
        noticeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalToSuperview().inset(24.adjustedW)
            $0.size.equalTo(24.adjustedW)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.adjustedH)
            $0.leading.equalTo(noticeImageView.snp.trailing).offset(4.adjustedW)
            $0.trailing.equalToSuperview().inset(24.adjustedW)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(noticeImageView.snp.bottom).offset(12.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        writtenTimeLabel.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalToSuperview().inset(16.adjustedH)
        }
    }
}

extension NoticeCardCell {
    
    func bind(
        backgroundColor: UIColor,
        iconImage: UIImage,
        title: String,
        subtitle: String,
        writtenTime: String
    ) {
        self.backgroundColor = backgroundColor
        noticeImageView.image = iconImage
        titleLabel.text = title
        subtitleLabel.text = subtitle
        writtenTimeLabel.text = writtenTime
    }
}
