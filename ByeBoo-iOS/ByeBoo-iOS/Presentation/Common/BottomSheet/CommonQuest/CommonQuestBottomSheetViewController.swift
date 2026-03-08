//
//  CommonQuestBottomSheetViewController.swift
//  ByeBoo-iOS
//
//  Created by 이나연 on 2/23/26.
//

import UIKit

protocol CommonQuestBottomSheetDelegate: AnyObject {
    func didTapEdit(
        answerID: Int,
        answer: String,
        question: String,
        writtenAt: String
    )
}

final class CommonQuestBottomSheetViewController: BaseViewController {
    
    private var rootView = CommonQuestBottomSheetView(sheetType: .other)
    var sheetType: CommonQuestArchiveType?
    private(set) var answerID: Int?
    private(set) var answer: String?
    private(set) var question: String?
    private(set) var writtenAt: String?
    weak var delegate: CommonQuestBottomSheetDelegate?
    
    override func loadView() {
        view = rootView
    }
    
    override func setAddTarget() {
        rootView.dismissButton.addTarget(self, action: #selector(dismissButtonDidTap), for: .touchUpInside)
        rootView.itemList.enumerated().forEach { index, item in
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(sheetItemDidTap(_:)))
            item.tag = index
            item.addGestureRecognizer(tapRecognizer)
            item.isUserInteractionEnabled = true
        }
    }
    
    func configure(
        sheeetType: CommonQuestArchiveType,
        answerID: Int? = nil,
        answer: String? = nil,
        question: String? = nil,
        writtenAt: String? = nil
    ) {
        self.sheetType = sheeetType
        self.answerID = answerID
        self.answer = answer
        self.question = question
        self.writtenAt = writtenAt
        
        if let sheetType {
            rootView = CommonQuestBottomSheetView(sheetType: sheetType)
        }
    }
    
    @objc
    private func sheetItemDidTap(_ tapRecognizer: UITapGestureRecognizer) {
        guard let tappedView = tapRecognizer.view,
              let sheetType = sheetType else { return }
        
        let index = tappedView.tag
        guard sheetType.items.indices.contains(index) else { return }
        
        let action = sheetType.items[index].action
        
        switch action {
        case .edit:
            guard let answerID, let answer, let question, let writtenAt
            else {
                return
            }
            
            dismiss(animated: false) { [weak self] in
                self?.delegate?.didTapEdit(
                    answerID: answerID,
                    answer: answer,
                    question: question,
                    writtenAt: writtenAt
                )
            }
        case .delete:
            // TODO: 삭제하기
            ByeBooLogger.debug("delete")
        case .block:
            // TODO: 차단하기
            ByeBooLogger.debug("block")
        case .report:
            // TODO: 신고하기
            ByeBooLogger.debug("report")
        }
    }
    
    @objc
    private func dismissButtonDidTap() {
        presentingViewController?.dismiss(animated: true)
    }
}
