//
//  CommonQuestHistoryViewController.swift
//  ByeBoo-iOS
//
//  Created by APPLE on 2/24/26.
//

import UIKit

import Mixpanel

final class CommonQuestHistoryViewController: BaseViewController {
    
    private let rootView = CommonQuestHistoryView()
    private var answerID: Int?
    private var answer: String?
    private var question: String?
    private var writtenAt: String?
    private var commonQuestArchiveType: CommonQuestArchiveType = .mine
    private var writerID: Int = 0
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
        Mixpanel.mainInstance().track(event: CommonJourneyEvents.Name.commonJourneyOthersAnswerPageview)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ByeBooNavigationBar.makeNavigationBar(
            navigationItem: self.navigationItem,
            navigationController: self.navigationController,
            type: .backAndMenu(header: .black),
            action: #selector(back),
            secondAction: #selector(bottomUp)
        )
    }
}

extension CommonQuestHistoryViewController: BackNavigable {
    
    func back() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestHistoryViewController: CommonQuestBottomSheetDelegate {
    
    func didTapEdit(
        answerID: Int,
        answer: String,
        question: String,
        writtenAt: String
    ) {
        let writeCommonQuestViewController = ViewControllerFactory.shared.makeWriteQuestionTypeQuestViewController()
        writeCommonQuestViewController.navigationItem.hidesBackButton = true
        writeCommonQuestViewController.questScope = .common
        writeCommonQuestViewController.configureToEdit(
            nil, .question, question, answerID, answer, writtenAt
        )
        self.navigationController?.pushViewController(writeCommonQuestViewController, animated: false)
    }
    
    @objc
    private func bottomUp() {
        let commonQuestBottomSheet = ViewControllerFactory.shared.makeCommonQuestBottomSheetViewController()
        commonQuestBottomSheet.configure(sheeetType: commonQuestArchiveType, writerID: writerID)
        commonQuestBottomSheet.configure(
            sheeetType: commonQuestArchiveType,
            answerID: answerID,
            answer: answer,
            question: question,
            writtenAt: writtenAt
        )
        setDelegate(bottomSheet: commonQuestBottomSheet)
      
        if let sheet =  commonQuestBottomSheet.sheetPresentationController{
            sheet.detents = [.custom { _ in 224.adjustedH }]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 8
        }
        self.present(commonQuestBottomSheet, animated: true)
    }
    
    private func setDelegate(bottomSheet: CommonQuestBottomSheetViewController) {
        bottomSheet.do {
            $0.bottomDelegate = self
            $0.deleteDelegate = self
            $0.blockDelegate = self
        }
    }
}

extension CommonQuestHistoryViewController: DeleteCommonQuestDelegate {
    func completeDeleteCommonQuest() {
        self.navigationController?.popViewController(animated: false)
    }
}

extension CommonQuestHistoryViewController {
    
    func configure(
        question: String,
        writtenAt: String,
        profileIcon: UIImage? = nil,
        nickname: String? = nil,
        content: String,
        answerID: Int? = nil,
        writerID: Int? = nil,
        isMyAnswer: Bool? = nil
    ) {
        self.answerID = answerID
        self.answer = content
        self.question = question
        self.writtenAt = writtenAt

        if let isMyAnswer {
            commonQuestArchiveType = isMyAnswer ? .mine : .other
        }
        
        if let writerID {
            self.writerID = writerID
        }
        
        rootView.configure(
            question: question,
            writtenAt: writtenAt,
            profileIcon: profileIcon,
            nickname: nickname,
            content: content
        )
    }
}

extension CommonQuestHistoryViewController: BlockReportProtocol {
    func completeBlockReport(type: CommonQuestArchiveType.Action) {
        ViewControllerUtils.changeQuestTabWithIndex(index: 1) {
            NotificationCenter.default.post(
                name: .showToastMessage,
                object: nil,
                userInfo: ["type": type]
            )
        }
    }
}
