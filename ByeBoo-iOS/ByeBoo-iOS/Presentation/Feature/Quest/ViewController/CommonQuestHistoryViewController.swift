//
//  CommonQuestHistoryViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

final class CommonQuestHistoryViewController: BaseViewController {
    
    private let rootView = CommonQuestHistoryView()
    private let bottomsheet = CommonQuestBottomSheetViewController()
    private var answerID: Int?
    private var answer: String?
    private var question: String?
    private var writtenAt: String?
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .backAndMenu(header: .black),
            action: #selector(back),
            secondAction: #selector(bottomsheetUp)
        )
    }
    
    override func setDelegate() {
        bottomsheet.delegate = self
    }
}

extension CommonQuestHistoryViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestHistoryViewController: CommonQuestBottomSheetDelegate {
    
    @objc
    private func bottomsheetUp() {
        bottomsheet.configure(
            sheeetType: .mine,
            answerID: answerID,
            answer: answer,
            question: question,
            writtenAt: writtenAt
        )
        
        if let sheet = bottomsheet.sheetPresentationController {
            sheet.detents = [.custom { _ in 224.adjustedH }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(bottomsheet, animated: true)
    }
    
    func didTapEdit(
        answerID: Int,
        answer: String,
        question: String,
        writtenAt: String
    ) {
        let writeCommonQuestViewController = ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController()
        writeCommonQuestViewController.navigationItem.hidesBackButton = true
        writeCommonQuestViewController.questScope = .common
        writeCommonQuestViewController.configure(
            nil, .question, question, answerID, answer, writtenAt
        )
        self.navigationController?.pushViewController(writeCommonQuestViewController, animated: false)
    }
}

extension CommonQuestHistoryViewController {
    
    func configure(
        question: String,
        writtenAt: String,
        profileIcon: UIImage? = nil,
        nickname: String? = nil,
        content: String,
        answerID: Int? = nil
    ) {
        self.answerID = answerID
        self.answer = content
        self.question = question
        self.writtenAt = writtenAt
        
        rootView.configure(
            question: question,
            writtenAt: writtenAt,
            profileIcon: profileIcon,
            nickname: nickname,
            content: content
        )
    }
}
