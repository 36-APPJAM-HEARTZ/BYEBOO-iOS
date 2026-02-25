//
//  JourneyListView.swift
//  ByeBoo-iOS
//
//  Created by 최주리 on 7/8/25.
//

import UIKit

protocol SelectUnCompletedJourneyProtocol: AnyObject {
    func addGesture()
}

protocol SelectCompletedJourneyProtocol: AnyObject {
    func addGesture()
}

final class JourneyListView: BaseView {
    
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    private let countLabel = UILabel()
    private(set) var journeyListView: UIStackView?
    private(set) var journeyViews: [OneLineTextBoxView] = []
    
    private let emptyLabel: UILabel?
    
    private let prepareView = OneLineTextBoxView(title: "")
    private let prepareTitleLabel = UILabel()
    
    private let isFinished: Bool
    private let journeyList: [JourneyEntity]
    
    weak var delegate: SelectUnCompletedJourneyProtocol?
    weak var completeJourneyDelegate: SelectCompletedJourneyProtocol?
    
    init(
        isFinished: Bool,
        journeyList: [JourneyEntity]
    ) {
        self.isFinished = isFinished
        self.journeyList = journeyList
        
        if journeyList.isEmpty && isFinished {
            emptyLabel = UILabel()
            journeyListView = nil
        } else {
            emptyLabel = nil
            journeyListView = UIStackView()
        }
        
        super.init(frame: .zero)
        
        titleLabel.text = isFinished ? "완료" : "미완료"
        countLabel.text = "\(journeyList.count)개"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setStyle() {
        backgroundColor = .grayscale900
        
        stackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        titleLabel.applyByeBooFont(style: .cap1M12, color: .grayscale300)
        countLabel.applyByeBooFont(style: .body2M16, color: .grayscale500)
        
        journeyListView?.do {
            $0.spacing = 16.adjustedH
            $0.axis = .vertical
            $0.isUserInteractionEnabled = true
        }
        
        emptyLabel?.applyByeBooFont (
            style: .body6R14,
            text: "아직 완료된 여정이 없어요!",
            color: .grayscale400
        )
        
        prepareTitleLabel.applyByeBooFont (
            style: .body6R14,
            text: "준비 중",
            color: .grayscale600
        )
    }
    
    override func setUI() {
        addSubviews(
            stackView
        )
        
        if let journeyListView {
            addSubviews(journeyListView)
            
            journeyListView.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
                $0.bottom.equalToSuperview().inset(16.adjustedH)
            }
        }
        
        stackView.addArrangedSubviews(
            titleLabel,
            countLabel
        )
        
        if !isFinished {
            journeyListView?.addArrangedSubview(prepareView)
            prepareView.addSubview(prepareTitleLabel)
            
            prepareView.snp.makeConstraints {
                $0.height.equalTo(65.adjustedH)
            }
            prepareTitleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
        if let emptyLabel {
            addSubview(emptyLabel)
        }
    }
    
    override func setLayout() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24.adjustedW)
        }
        
        if let emptyLabel {
            emptyLabel.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom).offset(176.5.adjustedH)
                $0.centerX.equalToSuperview()
            }
        }
    }
}

extension JourneyListView {
    func updateUI(journeyList: [JourneyEntity]) {
        if !journeyList.isEmpty {
            self.emptyLabel?.removeFromSuperview()
            journeyListView?.removeFromSuperview()
            
            journeyListView = UIStackView()
            addSubviews(journeyListView!)
            
            journeyListView?.do {
                $0.spacing = 16.adjustedH
                $0.axis = .vertical
                $0.isUserInteractionEnabled = true
            }
            
            journeyListView?.snp.makeConstraints {
                $0.top.equalTo(stackView.snp.bottom).offset(16.adjustedH)
                $0.horizontalEdges.equalToSuperview().inset(24.adjustedW)
                $0.bottom.equalToSuperview().inset(16.adjustedH)
            }
            
            journeyList.forEach { journey in
                let journeyView = OneLineTextBoxView(
                    title: journey.title + " 여정",
                    tagTitle: journey.questType?.title,
                    tagType: isFinished ? .word3Gray : .word3Purple,
                    isHighlighted: !isFinished
                )
                journeyView.snp.makeConstraints {
                    $0.height.equalTo(60.adjustedH)
                }
                journeyView.isUserInteractionEnabled = true
                journeyViews.append(journeyView)
            }
            journeyViews.forEach {
                journeyListView?.addArrangedSubview($0)
            }
            completeJourneyDelegate?.addGesture()
            
            if !isFinished {
                journeyListView?.addArrangedSubview(prepareView)
                prepareView.addSubview(prepareTitleLabel)
                
                prepareView.snp.makeConstraints {
                    $0.height.equalTo(62.adjustedH)
                }
                prepareTitleLabel.snp.makeConstraints {
                    $0.center.equalToSuperview()
                }
            }
            self.layoutIfNeeded()
            delegate?.addGesture()
        }
    }
    
    func updateCountLabel(count: Int) {
        countLabel.text = "\(count)개"
    }
}
