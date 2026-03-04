//
//  ArchiveQuestView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/7/25.
//

import UIKit

import Then
import Kingfisher
import SnapKit

final class ArchiveQuestView: BaseView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = ArchiveQuestHeaderView(
        stepNumber: 0,
        questNumber: 0,
        date: "",
        questTitle:""
    )
    private let textBoxView = TextBoxView(title: "")
    private let photoBoxView: UIImageView?
    private let feelView =  FeelView(emotionType: "", descriptionText: "")
    private let AIAnswerButton = ByeBooButton(
        titleText: "보리의 답장 보러가기",
        type: .enabled
    )
    
    private var descriptionText: String = ""
    private var photoURL: String = ""
    
    private(set) var type: QuestType
    
    init(type: QuestType) {
        self.type = type
        
        switch type {
        case .question:
            photoBoxView = nil
        case .activation:
            photoBoxView = UIImageView()
        }
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        photoBoxView?.do {
            $0.layer.cornerRadius = 12
            $0.clipsToBounds = true
            $0.backgroundColor = .gray
            $0.contentMode = .scaleAspectFill
            guard let url = URL(string: photoURL) else {
                ByeBooLogger.error(ByeBooError.URLError)
                return
            }
            $0.kf.setImage(with: url)
        }
    }
    
    override func setUI() {
        addSubviews(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            headerView,
            textBoxView,
            feelView,
            AIAnswerButton
        )
        
        if let photoBoxView {
            contentView.addSubview(photoBoxView)
        }
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.greaterThanOrEqualTo(scrollView.frameLayoutGuide)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        
        if let photoBoxView {
            photoBoxView.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom).offset(20.adjustedH)
                $0.size.equalTo(327.adjustedW)
                $0.centerX.equalToSuperview()
            }
        }
        
        textBoxView.snp.makeConstraints {
            if let photoBoxView {
                $0.top.equalTo(photoBoxView.snp.bottom).offset(20.adjustedH)
            } else {
                $0.top.equalTo(headerView.snp.bottom).offset(20.adjustedH)
            }
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
        }
        
        feelView.snp.makeConstraints {
            $0.top.equalTo(textBoxView.snp.bottom).offset(20.adjustedH)
            $0.horizontalEdges.equalToSuperview()
        }
        
        AIAnswerButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(feelView.snp.bottom).offset(44.adjustedH)
            $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
            $0.bottom.equalTo(contentView.snp.bottom).inset(36.adjustedH)
        }
    }
}

extension ArchiveQuestView {
    func updateUI(_ entity: QuestAnswerEntity) {
        self.headerView.updateUI(
            stepNumber: entity.stepNumber,
            questNumber: entity.questNumber,
            date: entity.createdAt,
            title: entity.question
        )
        
        feelView.updateUI(
            emotionType: entity.questEmotionState,
            descriptionText: entity.emotionDescription
        )
        
        switch type {
        case .question:
            textBoxView.updateText(entity.answer)
        case .activation:
            guard let photoBoxView else { return }
            
            guard let imageUrl = entity.imageUrl,
                let url = URL(string: imageUrl) else { return }
            photoBoxView.kf.setImage(with: url)
            
            if entity.answer.isEmpty {
                textBoxView.removeFromSuperview()
                
                feelView.snp.remakeConstraints {
                    $0.top.equalTo(photoBoxView.snp.bottom).offset(20.adjustedH)
                    $0.horizontalEdges.equalToSuperview()
                }
            } else {
                textBoxView.updateText(entity.answer)
                textBoxView.snp.remakeConstraints {
                    $0.top.equalTo(photoBoxView.snp.bottom).offset(20.adjustedH)
                    $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
                    $0.centerX.equalToSuperview()
                }
            }
        }
    }
}
