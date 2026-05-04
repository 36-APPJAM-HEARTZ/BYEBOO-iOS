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
    private var writtenTime: String = ""
    private var noticeType: NoticeDisplayable? {
        didSet {
            setStyle()
        }
    }
    
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
        guard let noticeType else { return }
        
        self.do {
            $0.layer.cornerRadius = 12
            $0.backgroundColor = noticeType.backgroundColor
        }
        noticeImageView.do {
            $0.image = noticeType.iconImage
        }
        titleLabel.applyByeBooFont(
            style: .body1Sb16,
            text: noticeType.title,
            color: .grayscale200,
            textAlignment: .left
        )
        subtitleLabel.applyByeBooFont(
            style: .body6R14,
            text: noticeType.subtitle,
            color: .grayscale100,
            textAlignment: .left
        )
        writtenTimeLabel.applyByeBooFont(
            style: .cap2R12,
            text: writtenTime,
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
    
    func bind(writtenTime: String, noticeType: NoticeDisplayable) {
        self.writtenTime = writtenTime
        self.noticeType = noticeType
    }
}
