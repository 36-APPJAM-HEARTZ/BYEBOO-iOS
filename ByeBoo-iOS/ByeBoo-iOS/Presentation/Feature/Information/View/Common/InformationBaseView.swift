//
//  InformationBaseView.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 7/7/25.
//

import UIKit

import SnapKit
import Then

final class InformationBaseView: BaseView {
    
    private let backgroundImageView = UIImageView()
    private var progressBarType: ProgressBarType
    private lazy var progressView = ProgressBarView(type: progressBarType)
    let informationView: BaseView
    private var nextButton = ByeBooButton(titleText: "다음으로", type: .disabled2)
    
    init(progressBarType: ProgressBarType, informationView: BaseView) {
        self.progressBarType = progressBarType
        self.informationView = informationView
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundImageView.do {
            $0.image = .bgNoLight
            $0.contentMode = .scaleAspectFill
        }
        
        if let view = informationView as? InputNicknameView {
            view.nicknameTextField.onRegex = { [weak self] condition in
                if condition {
                    self?.nextButton.updateType(.enabled)
                    return
                }
                self?.nextButton.updateType(.disabled2)
            }
        }
    }
    
    override func setUI() {
        addSubview(backgroundImageView)
        addSubviews(
            progressView,
            informationView,
            nextButton
        )
    }
    
    override func setLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
        }
        
        informationView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom)
            $0.width.equalTo(375.adjustedH)
            $0.height.equalTo(312.adjustedH)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(326.adjustedH)
            $0.height.equalTo(53.adjustedH)
        }
    }
}
